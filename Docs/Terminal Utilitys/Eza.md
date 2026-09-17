# Eza

Interactive fish uses Eza for `ls`, `ll`, `hls`, `hll`, and `tree` when the executable is available. Listings include icons and Git information; hidden variants include all files. The configured ignore glob excludes `System Volume Information` and names matching `?RECYCLE.BIN`.

The configuration calls `eza` directly instead of relying on the old workstation's `exa` symlink. If Eza is missing, these aliases are not created and the system `ls` remains available. See `fish/config.fish` for the exact options.
