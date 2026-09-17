# Personal dotfiles

Fish and Starship configuration, with Ghostty desktop helpers, for an Arch workstation and a personal server account. Services should define their own executable paths and environment rather than depend on interactive shell initialization.

## Documentation

See [Terminal configuration](Docs/Terminal%20Configuration.md) for the documentation index, including installation, Fish behavior, development tools, and workstation/server differences.

See [GNOME appearance setup](Docs/GNOME%20and%20GTK.md) for theme, cursor, and icon downloads, installation steps, and customized extensions.

## Configuration

- `fish/config.fish`: shared PATH, interactive Eza/Bat aliases, and Starship.
- `fish/conf.d/10-theme.fish`: explicit fish highlighting and completion-menu colors.
- `fish/conf.d/20-development.fish`: optional Rust, pnpm, Vite+, and fnm integration. Install development tools separately; fnm initializes after Vite+ to select ordinary Node commands. Verify project version switching when both are installed.
- `fish/conf.d/30-desktop.fish`: Ghostty, GNOME, Zed, and pfetch conveniences, only in local graphical interactive sessions.
- `fish/functions/towebp`: retained legacy conversion script; not an autoloaded fish function.
- `starship.toml`: existing prompt, shared across machines. Its icons need a Nerd Font in the client terminal.

Fish provides the usual suggestions and completion UI without additional plugins. The old fish-nvm/Bass wrappers and nvm completion have been removed in favor of fnm. Generated `fish_variables` is intentionally not versioned.

The personal `claude` alias retains `--dangerously-skip-permissions` from the current workstation. Remove that alias if that behavior is not wanted on a particular machine.

## Setup scripts

Run `./scripts/setup-terminal.sh` for the workstation, or add `--server` to omit Ghostty and desktop fonts. Run `./scripts/setup-gnome.sh` inside an existing GNOME session for themes and extensions. Both scripts accept `--dry-run` and back up replaced settings, keeping only the most recent backup.

See [Setup scripts](Docs/Setup%20scripts.md) for dependencies, options, and what each script changes.

## Manual install or update

Install Fish first. Starship, Eza, Bat, fnm, Rust, Vite+, pnpm, Ghostty, pfetch, GNOME, and Zed are optional. The setup scripts install the dependencies described in their guide; manual installation is also supported. Missing optional commands are skipped during startup.

Back up your existing fish configuration, then replace it with this repository's `fish` directory at `~/.config/fish`. Do not merge it over the old directory: leftover nvm functions or installer snippets can override or duplicate the new integrations. Keep the backup until a new shell has been verified. This replacement resets universal fish settings; history normally remains under `~/.local/share/fish`.

Copy `starship.toml` to `~/.config/starship.toml`, backing up the existing file first. Install Ghostty on the workstation; no terminal configuration file is bundled. The desktop fish snippet automatically skips headless and SSH sessions.

Do not copy `.obsidian`, keyboard firmware files, or desktop documentation into shell configuration. The `Docs` directory contains additional personal notes, some of which describe older setups.

Open a fresh interactive fish session and check the prompt, Tab completion, Node version switching, and `type -a node npm pnpm`. A noninteractive `fish -c true` should produce no startup banner. Keep Bash available for Bash scripts and administration. No login-shell change is required to try these settings.
