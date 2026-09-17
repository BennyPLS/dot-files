# Workstation and server

Both machines use the same fish configuration. Optional command checks determine which integrations are enabled; there is no separate profile selector.

| Feature | Local graphical interactive shell | SSH or headless interactive shell | Noninteractive shell |
| --- | --- | --- | --- |
| Local PATH, pnpm environment, optional Rust environment | Yes | Yes | Yes |
| Theme, common aliases, optional Starship | Yes | Yes | No |
| Optional fnm and Vite+ initialization | Yes | Yes | No |
| Ghostty/GNOME/Zed conveniences and optional pfetch | Yes | No | No |

The desktop snippet requires an interactive shell, no `SSH_CONNECTION`, and either `DISPLAY` or `WAYLAND_DISPLAY`. SSH with display forwarding still skips desktop conveniences. Desktop sessions without either display variable also skip them.

For the server, install development tools only if needed for occasional development. Ghostty, GNOME, and Zed are unnecessary for the shell configuration. Starship icons render in the SSH client's terminal, so the font belongs on the client.

Services should specify their executable and environment in their systemd configuration. Do not rely on fish aliases, interactive PATH changes, or automatic Node version switching to start services. Bash scripts can still run with Bash while Fish is used for interactive work.
