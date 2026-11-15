# CherryDots

My personal Linux dotfiles. CherryDots downloads files directly from GitHub and recreates their paths inside your home directory.

## Install

Run this command in a terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/cherryCTL/CherryDots/main/install.sh | sh
```

The installer reads the repository tree through the GitHub API and downloads each file individually. It does **not** clone the repository or download a ZIP archive.

## Repository layout

The `dots/` directory represents your home directory. Everything inside it is installed to the same relative path under `~`:

```text
CherryDots/
├── dots/
│   ├── .config/
│   │   ├── hypr/
│   │   │   └── hyprland.conf
│   │   └── kitty/
│   │       └── kitty.conf
│   ├── .local/
│   │   └── bin/
│   │       └── my-script
│   ├── bashrc
│   ├── zshrc
│   └── scripts/
│       └── helper.sh
├── install.sh
└── README.md
```

Examples:

| GitHub path | Installed path |
|---|---|
| `dots/.config/hypr/hyprland.conf` | `~/.config/hypr/hyprland.conf` |
| `dots/.config/kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `dots/.local/bin/my-script` | `~/.local/bin/my-script` |
| `dots/bashrc` | `~/bashrc` |
| `dots/scripts/helper.sh` | `~/scripts/helper.sh` |

There are no special folder names or hard-coded mappings. Add any file or directory under `dots/`, commit it, and the installer will discover it automatically. For example, use `dots/.bashrc` (not `dots/bashrc`) when you want the destination to be `~/.bashrc`.

## What it does

- Lists every file and its destination before installing.
- Marks files as `NEW` or `REPLACE` in the preview.
- Creates a backup before replacing an existing file.
- Preserves the executable bit recorded by Git.
- Leaves unrelated local files untouched.
- Does not delete local files that were removed from the repository.
- Skips Git symlinks and refuses unsafe destination conflicts, such as symbolic-link destinations or parent directories.

Backups are stored under:

```text
${XDG_STATE_HOME:-~/.local/state}/cherrydots/backups/
```

## Requirements

- Linux
- Internet connection
- Python 3

No `git`, `stow`, `jq`, or other installer dependencies are required.

## Notes

- The installer asks for confirmation before changing files. Type `y` to continue.
- Existing files with matching paths are backed up before replacement.
- `dots/` is mirrored to `$HOME`; therefore `dots/.config` goes to `~/.config` even if `XDG_CONFIG_HOME` is set to a custom location.
- Empty directories are not stored by Git and are not created by the installer. Add a placeholder file when an otherwise-empty directory must exist.
- Review the installer before running it, especially when installing on a new system.

For testing another repository or branch, set `CHERRYDOTS_REPO` and/or `CHERRYDOTS_BRANCH` before running the script.
