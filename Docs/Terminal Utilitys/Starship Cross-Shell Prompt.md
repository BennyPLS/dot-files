# Starship

The shared prompt is configured in `starship.toml`, installed at `~/.config/starship.toml`. Interactive fish initializes it only when `starship` is available; otherwise Fish keeps its default prompt.

The existing configuration displays the hostname, username, directory, Git and language/tool context, shell indicator, command status and duration, battery, sudo status, and memory usage when applicable. Modules may hide themselves according to their settings and environment.

The configuration is shared between workstation and server. Its icons require a suitable Nerd Font in the terminal displaying them, including the local terminal used for SSH. Changes to prompt styling belong in the TOML file rather than the fish theme.
