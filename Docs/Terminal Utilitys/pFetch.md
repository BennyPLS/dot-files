# pfetch

The desktop snippet runs pfetch only when it is installed and the shell is interactive, graphical, and not connected through SSH. Noninteractive commands and SSH sessions receive no pfetch banner from this configuration.

Remove the final pfetch block in `fish/conf.d/30-desktop.fish` to disable the banner. No separate pfetch configuration is included.
