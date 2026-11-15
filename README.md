# CherryDots

Personal Linux dotfiles.

## Install

```sh
curl -fsSL https://cdn.jsdelivr.net/gh/cherryCTL/CherryDots@main/install.sh | sh
```

Alternative CDN entry points, if the first host is unavailable:

```sh
curl -fsSL https://fastly.jsdelivr.net/gh/cherryCTL/CherryDots@main/install.sh | sh
curl -fsSL https://gcore.jsdelivr.net/gh/cherryCTL/CherryDots@main/install.sh | sh
```

The installer previews every destination and asks before making changes. Existing files are backed up first.

## Layout

Everything inside `dots/` maps to the same relative path under your home directory:

```text
CherryDots/
├── dots/
│   ├── .config/hypr/hyprland.conf
│   ├── .config/kitty/kitty.conf
│   ├── .local/bin/my-script
│   ├── .bashrc
│   └── scripts/helper.sh
├── install.sh
└── README.md
```

For example, `dots/.config/hypr/hyprland.conf` installs to `~/.config/hypr/hyprland.conf`, and `dots/.bashrc` installs to `~/.bashrc`. There are no special folder names or hard-coded path mappings.

## Behaviour

- Lists files as `NEW` or `REPLACE` before installation.
- Requires confirmation (`y`) before downloading and installing.
- Backs up replaced files under `${XDG_STATE_HOME:-~/.local/state}/cherrydots/backups/`.
- Leaves unrelated local files and files removed from the repository untouched.
- Downloads files individually. It does not clone the repository or download a ZIP.
- Tries jsDelivr's metadata API and CDN mirrors first, then GitHub as a fallback.
- Respects standard `HTTPS_PROXY`, `HTTP_PROXY` and `ALL_PROXY` environment variables through Python's URL handling.

## Requirements

- Linux
- Python 3
- Network access to at least one supported CDN or GitHub endpoint

For an unattended install only, set `CHERRYDOTS_YES=1`. Without an interactive terminal, the installer stops without changing files. An interactive SSH session can confirm; for a remote command that does not allocate a terminal, use `ssh -t` to request one.

## Notes

- New files use regular user-file permissions. When replacing a local file, its existing permission bits are preserved; when GitHub's API is available, the repository's executable bit is applied.
- jsDelivr caches branch URLs, so a recent push may take some time to appear through the CDN (the documented branch cache period is up to 12 hours).
- Empty directories are not stored by Git and are not created by the installer.
