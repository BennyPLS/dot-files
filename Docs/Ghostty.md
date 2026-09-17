# Ghostty

Ghostty is the workstation terminal. This repository uses its current appearance and does not include a Ghostty configuration file or custom terminal keybindings.

Fish aliases, completion, highlighting, and the Starship prompt are configured separately and remain available when Ghostty launches Fish. Confirm the shell with `status fish-path` in a Fish session.

In a local graphical interactive session, the desktop snippet defines `term` to launch `ghostty`, forward arguments, and disown the process. `rterm` calls `term` and exits the shell if it succeeds. The helpers preserve the current display environment and are only defined when the Ghostty command is available.

SSH and headless sessions skip these helpers. Ghostty is not needed on the server; the local terminal displays the remote shell. Prompt icons depend on the font used by that terminal.
