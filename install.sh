#!/bin/sh
set -eu

# CherryDots remote installer. Override these when testing another repository/branch.
REPO="${CHERRYDOTS_REPO:-cherryCTL/CherryDots}"
BRANCH="${CHERRYDOTS_BRANCH:-main}"
HOME_TARGET="$HOME"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/cherrydots/backups"

command -v python3 >/dev/null 2>&1 || {
    printf '%s\n' 'CherryDots requires Python 3. Install python3 and try again.' >&2
    exit 1
}

exec python3 - "$REPO" "$BRANCH" "$HOME_TARGET" "$STATE_DIR" <<'PY'
import json
import locale
import os
import re
import shutil
import sys
import tempfile
import unicodedata
from datetime import datetime
from pathlib import Path, PurePosixPath
from urllib.error import HTTPError, URLError
from urllib.parse import quote, unquote, urlparse, urljoin
from urllib.request import Request, urlopen
from html.parser import HTMLParser

repo, branch, home_target_arg, state_dir_arg = sys.argv[1:]

if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", repo):
    raise SystemExit("Invalid GitHub repository. Expected owner/repository.")
if not branch.strip():
    raise SystemExit("Git branch cannot be empty.")

home_root = Path(home_target_arg).expanduser().resolve()
state_root = Path(state_dir_arg).expanduser()

# Sakura-inspired terminal palette. Respect NO_COLOR and TERM=dumb.
COLOR = (
    sys.stdout.isatty()
    and "NO_COLOR" not in os.environ
    and os.environ.get("TERM", "") != "dumb"
)
PALETTE = {
    "primary": "#C7A5E8",
    "secondary": "#91C7E8",
    "text": "#E8E2EF",
    "muted": "#A39BAB",
    "ok": "#8FD2A7",
    "warn": "#E8C47C",
    "error": "#EF929F",
}


def rgb(hex_color):
    value = hex_color.lstrip("#")
    return tuple(int(value[i:i + 2], 16) for i in (0, 2, 4))


def paint(value, role):
    value = str(value)
    if not COLOR:
        return value
    r, g, b = rgb(PALETTE[role])
    return f"\033[38;2;{r};{g};{b}m{value}\033[0m"


UNICODE = (
    os.environ.get("CHERRYDOTS_ASCII") != "1"
    and os.environ.get("TERM", "") != "dumb"
    and "utf" in (sys.stdout.encoding or locale.getpreferredencoding(False) or "").lower()
)
if UNICODE:
    GLYPHS = {
        "tl": "╭", "tr": "╮", "bl": "╰", "br": "╯",
        "h": "─", "v": "│", "tee": "├", "flower": "✿",
        "bullet": "•", "arrow": "→", "check": "✓", "cross": "✕",
    }
else:
    GLYPHS = {
        "tl": "+", "tr": "+", "bl": "+", "br": "+",
        "h": "-", "v": "|", "tee": "+", "flower": "*",
        "bullet": "*", "arrow": "->", "check": "+", "cross": "x",
    }


def visible_width(value):
    value = re.sub(r"\033\[[0-9;]*m", "", str(value))
    width = 0
    for char in value:
        if unicodedata.combining(char):
            continue
        width += 2 if unicodedata.east_asian_width(char) in ("W", "F") else 1
    return width


def terminal_width():
    try:
        return max(28, min(shutil.get_terminal_size((84, 24)).columns, 100))
    except OSError:
        return 84


def fit(value, width):
    value = str(value)
    current_width = visible_width(value)
    if current_width <= width:
        return value + " " * (width - current_width)

    result = ""
    used = 0
    truncated = False
    tokens = re.findall(r"\033\[[0-9;]*m|.", value, flags=re.S)
    for token in tokens:
        if token.startswith("\033["):
            result += token
            continue
        char_width = 0 if unicodedata.combining(token) else (2 if unicodedata.east_asian_width(token) in ("W", "F") else 1)
        if used + char_width > max(0, width - 1):
            truncated = True
            break
        result += token
        used += char_width
    if truncated:
        result += "…"
        used += 1
    if "\033[" in result:
        result += "\033[0m"
    return result + " " * max(0, width - used)


def panel(title, lines, status=None, width=None):
    """Draw a consistently sized Sakura Island with aligned top/body/bottom edges."""
    term_w = terminal_width()
    max_width = max(24, min(96, term_w - 2))
    line_width = max(
        [visible_width(line) for line in lines] + [0]
    )

    left_raw = f" {GLYPHS['flower']} {title} "
    right_raw = f" {status} " if status else ""
    title_width = visible_width(left_raw) + visible_width(right_raw)
    desired = max(32, line_width + 4, title_width + 4)
    width = min(max_width, width or desired)
    width = max(min(24, max_width), width)

    # One horizontal glyph must remain between the title and the right edge.
    title_budget = max(0, width - 4)
    right_budget = min(visible_width(right_raw), max(0, title_budget - 4))
    left_budget = max(0, title_budget - right_budget)
    left_title = fit(left_raw, left_budget)
    right_title = fit(right_raw, right_budget) if right_budget else ""
    room = width - 3 - visible_width(left_title) - visible_width(right_title)

    top = (
        GLYPHS["tl"] + GLYPHS["h"] + left_title
        + GLYPHS["h"] * max(1, room) + right_title + GLYPHS["tr"]
    )
    print(paint(top, "primary"))

    # The body has exactly width-4 content cells plus two borders and two spaces.
    body_width = width - 4
    for line in lines:
        body = fit(line, body_width)
        print(
            paint(GLYPHS["v"], "primary") + " " + body + " "
            + paint(GLYPHS["v"], "primary")
        )

    print(paint(GLYPHS["bl"] + GLYPHS["h"] * (width - 2) + GLYPHS["br"], "primary"))


def http_get(url, accept="*/*"):
    # urllib automatically honours HTTPS_PROXY / HTTP_PROXY / ALL_PROXY.
    request = Request(url, headers={
        "User-Agent": "CherryDots-Installer/1.3 (+https://github.com/cherryCTL/CherryDots)",
        "Accept": accept,
        "Cache-Control": "no-cache",
    })
    with urlopen(request, timeout=10) as response:
        return response.read()


CDN_HOSTS = (
    "cdn.jsdelivr.net",
    "fastly.jsdelivr.net",
    "gcore.jsdelivr.net",
    "testingcf.jsdelivr.net",
    "quantil.jsdelivr.net",
)
DOWNLOAD_HOST_HINT = None


class DirectoryLinks(HTMLParser):
    def __init__(self):
        super().__init__()
        self.hrefs = []

    def handle_starttag(self, tag, attrs):
        if tag.lower() == "a":
            href = dict(attrs).get("href")
            if href:
                self.hrefs.append(href)


def jsdelivr_file_list():
    """Read the flat file list from jsDelivr's public GitHub package API."""
    url = (
        f"https://data.jsdelivr.com/v1/packages/gh/{repo}"
        f"@{quote(branch, safe='/')}?structure=flat"
    )
    data = json.loads(http_get(url, "application/json"))
    files = data.get("files") if isinstance(data, dict) else None
    if not isinstance(files, list):
        raise ValueError("jsDelivr returned an unexpected file-list response")

    found = []
    for item in files:
        if not isinstance(item, dict):
            continue
        name = item.get("name")
        if not isinstance(name, str):
            continue
        path = name.lstrip("/")
        # Flat listings contain files. Ignore directory entries if supplied.
        if item.get("type") in ("directory", "dir") or "files" in item:
            continue
        if path.startswith("dots/"):
            found.append({"source": path, "mode": None})
    return found


def cdn_directory_file_list(host):
    """Fallback for networks where the metadata API is unreachable."""
    package_prefix = f"/gh/{repo}@{quote(branch, safe='/')}/"
    base_url = f"https://{host}{package_prefix}"
    queue = ["dots/"]
    visited = set()
    found = {}
    pages = 0

    while queue:
        directory = queue.pop(0)
        if directory in visited:
            continue
        visited.add(directory)
        pages += 1
        if pages > 500:
            raise ValueError("Repository contains too many directories for CDN listing")

        page_url = base_url + quote(directory, safe="/")
        html = http_get(page_url, "text/html,*/*")
        parser = DirectoryLinks()
        parser.feed(html.decode("utf-8", errors="replace"))

        for href in parser.hrefs:
            resolved = urlparse(urljoin(page_url, href))
            if resolved.scheme != "https" or resolved.netloc != host:
                continue
            resolved_path = unquote(resolved.path)
            if not resolved_path.startswith(package_prefix):
                continue
            relative_path = resolved_path[len(package_prefix):]
            if not relative_path.startswith("dots/"):
                continue
            if relative_path == directory or relative_path in ("dots", "dots/"):
                continue
            if relative_path.endswith("/"):
                if relative_path not in visited:
                    queue.append(relative_path)
            elif safe_relative_path(relative_path[len("dots/"):]):
                found[relative_path] = {"source": relative_path, "mode": None}

    return list(found.values())


def github_api_file_list():
    """Fallback to GitHub's tree API when CDN metadata is unavailable."""
    api_url = (
        f"https://api.github.com/repos/{repo}/git/trees/"
        f"{quote(branch, safe='')}?recursive=1"
    )
    data = json.loads(http_get(api_url, "application/vnd.github+json"))
    if data.get("truncated"):
        raise ValueError("GitHub returned an incomplete file tree")

    found = []
    for item in data.get("tree", []):
        path = item.get("path", "")
        if item.get("type") != "blob" or not path.startswith("dots/"):
            continue
        if item.get("mode") not in ("100644", "100755"):
            continue
        found.append({"source": path, "mode": item.get("mode")})
    return found


def get_file_list():
    errors = []
    try:
        files = jsdelivr_file_list()
        if files:
            return files, "jsDelivr"
        errors.append("jsDelivr API: no files found under dots/")
    except Exception as exc:
        errors.append(f"jsDelivr API: {exc}")

    for host in CDN_HOSTS:
        try:
            files = cdn_directory_file_list(host)
            if files:
                return files, f"{host}"
        except Exception as exc:
            errors.append(f"{host}: {exc}")

    try:
        files = github_api_file_list()
        if files:
            return files, "GitHub API"
        errors.append("GitHub API: no files found under dots/")
    except Exception as exc:
        errors.append(f"GitHub API: {exc}")

    raise RuntimeError("Could not reach any supported repository source. " + " | ".join(errors[-4:]))


def download_file(source, preferred_source):
    global DOWNLOAD_HOST_HINT
    encoded_path = quote(source, safe="/")
    preferred_hosts = []
    if preferred_source in CDN_HOSTS:
        preferred_hosts.append(preferred_source)
    if DOWNLOAD_HOST_HINT in CDN_HOSTS and DOWNLOAD_HOST_HINT not in preferred_hosts:
        preferred_hosts.append(DOWNLOAD_HOST_HINT)
    preferred_hosts.extend(host for host in CDN_HOSTS if host not in preferred_hosts)

    cdn_urls = [
        f"https://{host}/gh/{repo}@{quote(branch, safe='/')}/{encoded_path}"
        for host in preferred_hosts
    ]
    raw_url = (
        f"https://raw.githubusercontent.com/{repo}/"
        f"{quote(branch, safe='')}/{encoded_path}"
    )
    urls = cdn_urls + [raw_url]
    if preferred_source == "GitHub API":
        urls = [raw_url] + cdn_urls

    errors = []
    for url in urls:
        try:
            content = http_get(url)
            DOWNLOAD_HOST_HINT = urlparse(url).netloc
            return content, DOWNLOAD_HOST_HINT
        except Exception as exc:
            errors.append(f"{urlparse(url).netloc}: {exc}")
    raise RuntimeError("; ".join(errors))


def fail(message, detail=None):
    rows = [paint(message, "error")]
    if detail:
        rows.append(paint(detail, "muted"))
    panel("Installation stopped", rows, status="ERROR")
    raise SystemExit(1)


def safe_relative_path(path):
    pure = PurePosixPath(path)
    return (
        not pure.is_absolute()
        and bool(pure.parts)
        and all(part not in ("", ".", "..") for part in pure.parts)
    )


def destination_problem(root, relative, destination):
    """Return a reason when a destination is unsafe or conflicts with the filesystem."""
    if root.exists() and not root.is_dir():
        return f"Target root is not a directory: {root}"

    current = root
    for part in PurePosixPath(relative).parts[:-1]:
        current = current / part
        if current.is_symlink():
            return f"Parent path is a symbolic link: {current}"
        if current.exists() and not current.is_dir():
            return f"Parent path is not a directory: {current}"

    if destination.is_symlink():
        return f"Destination is a symbolic link: {destination}"
    if destination.exists() and not destination.is_file():
        return f"Destination exists but is not a regular file: {destination}"

    try:
        resolved_parent = destination.parent.resolve()
        if os.path.commonpath((str(root), str(resolved_parent))) != str(root):
            return f"Destination escapes its target directory: {destination}"
    except (OSError, ValueError):
        return f"Could not safely resolve destination: {destination}"
    return None


def display_destination(relative):
    return f"~/{relative}"


def ask_confirmation():
    if os.environ.get("CHERRYDOTS_YES") == "1":
        return True

    # `curl | sh` owns stdin for the script body, so never read the answer
    # from stdin. Find the user's actual terminal, even when stdout is piped.
    candidates = []
    tty_env = os.environ.get("TTY")
    if tty_env:
        candidates.append(tty_env)
    candidates.append("/dev/tty")
    for fd in (0, 1, 2):
        try:
            if os.isatty(fd):
                candidates.append(os.ttyname(fd))
        except OSError:
            pass

    seen = set()
    for path in candidates:
        if not path or path in seen:
            continue
        seen.add(path)
        try:
            fd = os.open(path, os.O_RDWR | getattr(os, "O_CLOEXEC", 0))
            if not os.isatty(fd):
                os.close(fd)
                continue
            try:
                os.write(fd, "\n  Install these files? [y/N] ".encode("utf-8"))
                answer = bytearray()
                while True:
                    char = os.read(fd, 1)
                    if not char or char in (b"\n", b"\r"):
                        break
                    answer.extend(char)
                return answer.decode("utf-8", errors="replace").strip().lower() in ("y", "yes")
            finally:
                os.close(fd)
        except OSError:
            continue

    fail(
        "Cannot ask for confirmation in this session.",
        "No files were changed. Run from an interactive terminal/SSH session; use CHERRYDOTS_YES=1 only for unattended installs.",
    )


def main():
    print()
    header = [
        f"{paint(repo, 'secondary')}  {paint('@' + branch, 'muted')}",
    ]
    panel("CherryDots", header, status="INSTALLER")

    print("\n  " + paint("Checking download sources...", "secondary"))
    try:
        remote_files, list_source = get_file_list()
    except Exception as exc:
        fail(
            "Could not retrieve the CherryDots file list.",
            f"Check your connection to jsDelivr/GitHub or configure HTTPS_PROXY.\n{exc}",
        )
    print("  " + paint(f"Source: {list_source}", "muted"))

    # Treat dots/ as the user's home directory. Every tracked regular file
    # keeps its path relative to dots/, with no special folders or mappings.
    prefix = "dots/"
    entries = []
    for item in remote_files:
        path = item.get("source", "")
        if not path.startswith(prefix):
            continue
        relative = path[len(prefix):]
        if not safe_relative_path(relative):
            fail("An unsafe path was found in the repository.", path)

        # Only ordinary files are fetched. Symlinks and special files are skipped.
        destination = home_root.joinpath(*PurePosixPath(relative).parts)
        problem = destination_problem(home_root, relative, destination)
        if problem:
            status = "BLOCKED"
        elif destination.is_file():
            status = "REPLACE"
        else:
            status = "NEW"

        entries.append({
            "source": path,
            "relative": relative,
            "root": home_root,
            "destination": destination,
            "display": display_destination(relative),
            "status": status,
            "mode": item.get("mode"),
            "problem": problem,
        })

    entries.sort(key=lambda entry: entry["relative"].lower())
    if not entries:
        fail("No regular files were found inside dots/.", "Add the files and folders you want mirrored into your home directory.")

    # Do not allow two repository files to target the same local path.
    destinations = {}
    for entry in entries:
        key = os.path.normcase(str(entry["destination"]))
        if key in destinations:
            entry["status"] = "BLOCKED"
            entry["problem"] = f"Destination collision with {destinations[key]}"
        else:
            destinations[key] = entry["source"]

    blocked = [entry for entry in entries if entry["status"] == "BLOCKED"]
    new_count = sum(entry["status"] == "NEW" for entry in entries)
    replace_count = sum(entry["status"] == "REPLACE" for entry in entries)

    max_path_width = max(25, min(66, terminal_width() - 31))
    file_lines = []
    for entry in entries:
        role = "ok" if entry["status"] == "NEW" else "warn" if entry["status"] == "REPLACE" else "error"
        file_lines.append(f"{fit(entry['display'], max_path_width)}  {paint(entry['status'], role)}")
    panel(f"Files to install ({len(entries)})", file_lines)

    summary_lines = [
        f"New files       {paint(str(new_count), 'ok')}",
        f"Existing files  {paint(str(replace_count), 'warn')}",
        f"Home target     {paint(str(home_root), 'text')}",
        f"Backup          {paint(str(state_root / '<timestamp>'), 'muted') if replace_count else paint('Not needed', 'muted')}",
    ]
    panel("Install summary", summary_lines, status=f"{len(entries)} FILES")

    if blocked:
        print("\n  " + paint("Blocked paths", "error"))
        for entry in blocked:
            print("  " + paint(GLYPHS["cross"], "error") + " " + entry["source"])
            if entry.get("problem"):
                print("    " + paint(entry["problem"], "muted"))
        fail("Resolve the blocked destination conflicts before installing.")

    if not ask_confirmation():
        print("\n  " + paint("Cancelled. No files were changed.", "muted") + "\n")
        return

    # Fetch every file before creating directories, backups or changing user files.
    print("\n  " + paint("Downloading files...", "secondary"))
    payloads = []
    for index, entry in enumerate(entries, 1):
        try:
            content, _used_source = download_file(entry["source"], list_source)
        except Exception as exc:
            fail(f"Could not download {entry['source']}.", str(exc))
        payloads.append((entry, content))
        print(f"  {paint(f'[{index:>2}/{len(entries)}]', 'muted')} {paint(GLYPHS['check'], 'ok')} {entry['display']}  {paint('ready', 'ok')}")

    backup_dir = None
    if replace_count:
        stamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")
        backup_dir = state_root / stamp
        backup_dir.mkdir(parents=True, exist_ok=False, mode=0o700)

    # Back up all existing files first. No target is changed until backups finish.
    try:
        if backup_dir:
            for entry, _content in payloads:
                if entry["status"] != "REPLACE":
                    continue
                backup_file = backup_dir / PurePosixPath(entry["relative"])
                backup_file.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(entry["destination"], backup_file)
    except Exception as exc:
        fail("Could not finish creating backups. No files were installed.", f"{exc}\nBackup directory: {backup_dir}")

    installed = []
    try:
        for entry, content in payloads:
            root = entry["root"]
            destination = entry["destination"]
            problem = destination_problem(root, entry["relative"], destination)
            if problem:
                raise RuntimeError(problem)

            destination.parent.mkdir(parents=True, exist_ok=True)
            # Re-check after mkdir to avoid following a changed/symlinked parent path.
            problem = destination_problem(root, entry["relative"], destination)
            if problem:
                raise RuntimeError(problem)

            fd, temporary_name = tempfile.mkstemp(prefix=".cherrydots-", dir=str(destination.parent))
            try:
                with os.fdopen(fd, "wb") as handle:
                    handle.write(content)
                    handle.flush()
                    os.fsync(handle.fileno())
                if entry["mode"] == "100755":
                    file_mode = 0o755
                elif entry["status"] == "REPLACE":
                    file_mode = entry["destination"].stat().st_mode & 0o777
                else:
                    file_mode = 0o644
                os.chmod(temporary_name, file_mode)
                os.replace(temporary_name, destination)
            finally:
                if os.path.exists(temporary_name):
                    os.unlink(temporary_name)

            installed.append(entry)
            print(f"  {paint(GLYPHS['check'], 'ok')} {entry['display']}")
    except Exception as exc:
        # Best-effort rollback: restore replaced files and remove newly-created files.
        rollback_errors = []
        for entry in reversed(installed):
            destination = entry["destination"]
            try:
                if entry["status"] == "REPLACE" and backup_dir:
                    backup_file = backup_dir / PurePosixPath(entry["relative"])
                    fd, temporary_name = tempfile.mkstemp(prefix=".cherrydots-rollback-", dir=str(destination.parent))
                    try:
                        with os.fdopen(fd, "wb") as handle, open(backup_file, "rb") as source_handle:
                            shutil.copyfileobj(source_handle, handle)
                            handle.flush()
                            os.fsync(handle.fileno())
                        shutil.copystat(backup_file, temporary_name)
                        os.replace(temporary_name, destination)
                    finally:
                        if os.path.exists(temporary_name):
                            os.unlink(temporary_name)
                else:
                    destination.unlink(missing_ok=True)
            except Exception as rollback_exc:
                rollback_errors.append(f"{destination}: {rollback_exc}")

        detail = f"{exc}\nBackups: {backup_dir or 'none'}"
        if rollback_errors:
            detail += "\nRollback warnings: " + "; ".join(rollback_errors)
        fail("Installation failed. A rollback was attempted.", detail)

    done_lines = [
        f"Installed        {paint(str(len(installed)), 'ok')}",
        f"Backed up        {paint(str(replace_count), 'secondary')}",
        f"Home target      {paint(str(home_root), 'text')}",
    ]
    if backup_dir:
        done_lines.append(f"Backup location  {paint(str(backup_dir), 'muted')}")
    panel("Installation complete", done_lines, status="DONE")
    print("\n  " + paint(f"{GLYPHS['flower']} CherryDots is ready.", "primary") + "\n")


try:
    main()
except KeyboardInterrupt:
    print("\n  " + paint("Cancelled by user.", "warn"))
    raise SystemExit(130)
PY
