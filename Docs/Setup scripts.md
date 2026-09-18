# Setup scripts

Run these scripts as your regular user. They call sudo for Arch package installation. They do not run automatically when the repository is cloned.

## Terminal

```sh
./scripts/setup-terminal.sh --dry-run
./scripts/setup-terminal.sh
```

The workstation setup installs Fish, Starship, Eza, Bat, fzf, Ghostty, and JetBrains Mono Nerd Fonts. It replaces `~/.config/fish` and `~/.config/starship.toml` with the repository copies, after moving existing files into a new directory under `~/dotfiles-backups/`. Each run removes the previous backup there before creating its own. Replacing the fish directory removes stale nvm wrappers from the active configuration. History under `~/.local/share/fish` stays in place; old universal settings stay in the backup.

| Option | Effect |
| --- | --- |
| `--server` | Omit Ghostty and desktop fonts |
| `--skip-packages` | Copy configuration using already installed dependencies |
| `--login-shell` | Run `chsh` to select Fish after copying configuration |
| `--dry-run` | Print intended changes without network requests or writes |

Node, fnm, Rust, pnpm, Vite+, pfetch, and editor tools remain separate installations. The fish configuration enables their integrations when available. No Ghostty configuration file is created. Without `--login-shell`, try the result by opening `fish` explicitly.

## GNOME

Start with GNOME installed and a logged-in graphical session:

```sh
./scripts/setup-gnome.sh --dry-run
./scripts/setup-gnome.sh
```

The script installs build tools, GNOME Tweaks, and fonts through pacman. It downloads Graphite and Candy into a temporary directory, builds Graphite with `-t red -c dark --tweaks nord rimless -l`, and installs Candy for the user. The downloads are removed when the script exits. It selects the documented themes and fonts through gsettings.

For Oreo Spark Red, the script reuses an installed copy if found. Otherwise it downloads the upstream source, generates the cursor variants, builds them, and installs only `oreo_spark_red_cursors`. The build can take several minutes. To use a downloaded and extracted prebuilt theme instead:

```sh
./scripts/setup-gnome.sh --cursor-dir "$HOME/Downloads/oreo_spark_red_cursors"
```

The script queries extensions.gnome.org for each listed extension's release compatible with the installed GNOME major version. It validates downloaded metadata, installs the extensions, imports their saved settings, and adds their UUIDs to the enabled list without dropping other enabled extensions. Existing extension files and settings are backed up. If an extension has no compatible release on extensions.gnome.org, the script skips that one with a warning rather than installing an incompatible version or aborting the batch: its UUID stays in the enabled list and its saved settings are still applied, but you must install it manually (for example Unite from [hardpixel/unite-shell](https://github.com/hardpixel/unite-shell) when no release is tagged for the current GNOME). Earlier theme and font changes may already have been applied.

Log out and back in after completion. Review Dash to Panel's monitor selection and gSnap's workspace assignments. ArcMenu's captured GNOME Terminal pin can be replaced with Ghostty through its preferences.

| Option | Effect |
| --- | --- |
| `--skip-packages` | Require dependencies to be installed already |
| `--gdm` | Also install the root-owned GDM theme and pacman hook |
| `--skip-extensions` | Set up appearance without installing or configuring extensions or gSnap layouts |
| `--cursor-dir DIR` | Install this extracted Oreo Spark Red theme instead of building it |
| `--dry-run` | Print the plan without downloading, installing, or changing settings |

The GNOME script requires the default `~/.config` location because Graphite's installer writes GTK 4 links there. GDM setup is optional through `--gdm`; see [GDM](GDM.md). It does not configure monitors, power settings, wallpaper, or `.profile`. See [GNOME appearance setup](GNOME%20and%20GTK.md) for upstream downloads and the GTK 4 explanation.

## Repeated runs and backups

Every real run removes the previous backup directory, creates a new one, and prints its location. Keep a copy elsewhere before rerunning if you still need an older backup. Upstream sources are downloaded fresh on each run and removed afterwards, so every run uses the current upstream release. The GNOME script records the source commits in the backup directory. Extension downloads select the available compatible releases on each run.

Package installation uses `pacman -S --needed` with normal package-manager prompts. Keep the Arch installation up to date before running setup. The obsolete GTK 2 Murrine dependency mentioned by Graphite upstream is not needed for this GTK 3/4 setup and is not installed.

To undo terminal configuration changes, move the new installed files aside and restore the backed-up fish directory and Starship file. To undo GNOME settings, load `interface.dconf` at `/org/gnome/desktop/interface/` and `extensions.dconf` at `/org/gnome/shell/extensions/`, then restore the saved enabled-extension list and backed-up theme/GTK files. dconf loads restore recorded values but do not clear newly added keys. Backups are not an automatic transaction rollback; review them if a setup stops partway through. No script uninstalls packages during rollback.
