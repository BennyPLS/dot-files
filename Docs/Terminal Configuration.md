# Terminal configuration

See [Setup scripts](Setup%20scripts.md) for automated terminal and GNOME installation.

This repository configures Fish and Starship with Ghostty desktop helpers for an Arch Linux workstation and a personal server account. Fish remains the interactive shell, with its built-in suggestions and completion interface. No zsh migration or shell plugin framework is included.

## Documentation

- [Installation and updates](Installation.md): destinations, backups, verification, and rollback.
- [Fish](Fish.md): startup order, aliases, completion, and development tools.
- [Workstation and server](Workstation%20and%20Server.md): which settings run in each environment.
- [Ghostty](Ghostty.md): workstation terminal and launch helpers.
- [Starship](Terminal%20Utilitys/Starship%20Cross-Shell%20Prompt.md): prompt configuration.
- [Eza](Terminal%20Utilitys/Eza.md), [Bat](Terminal%20Utilitys/Bat.md), and [pFetch](Terminal%20Utilitys/pFetch.md): optional terminal utilities.

- [GNOME appearance setup](GNOME%20and%20GTK.md): theme downloads, installation, and extension configuration.

## Repository map

| Source | Purpose |
| --- | --- |
| `fish/config.fish` | Shared local executable path, interactive aliases, Starship |
| `fish/conf.d/10-theme.fish` | Interactive highlighting and completion-menu colors |
| `fish/conf.d/20-development.fish` | Rust, pnpm, Vite+, and fnm integration |
| `fish/conf.d/30-desktop.fish` | Local graphical-session conveniences |
| `fish/functions/towebp` | Legacy PNG conversion script, not an autoloaded fish function |
| `starship.toml` | Shared prompt |
| `50-qmk.rules`, `k4_pro_iso_rgb_v1.00.json` | Separate keyboard-related files; not installed with the shell |

The setup scripts install their documented packages. They do not configure services. The GNOME appearance guide covers themes and configured extensions; NeoVim remains a separate personal note. Obsidian files are editor state, not terminal configuration.
