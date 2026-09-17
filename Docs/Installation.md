# Installation and updates

See [Setup scripts](Setup%20scripts.md) for automated terminal and GNOME installation.

## Requirements

Install Fish on the target machine before applying its configuration. Install optional tools separately when needed: Starship, Eza, Bat, fnm, Rust, pnpm, Vite+, Ghostty, pfetch, Zed, and GNOME. The setup scripts install the packages listed in their guide. Development runtimes remain separate installations.

These instructions use the default `~/.config` location. If `XDG_CONFIG_HOME` is customized, use that directory instead.

## Apply the configuration

1. Keep an existing terminal open. Back up `~/.config/fish` and `~/.config/starship.toml` to a dated location outside the destination directories.
2. Move the existing fish directory out of the way, then copy the repository's entire `fish` directory to `~/.config/fish`. Do not merge directories: old nvm wrappers, generated theme files, and installer snippets can otherwise remain active.
3. Copy `starship.toml` to `~/.config/starship.toml`.
4. Install Ghostty on the workstation. No Ghostty configuration needs to be copied from this repository; use its current appearance. Omit the terminal installation on the server.
5. Open a fresh fish session and verify the checks below before closing the original terminal.

Replacing the fish directory resets untracked universal settings. Keep its backup if you need to recover them. Do not restore the old `fish_variables` wholesale: the old repository version contains obsolete nvm plugin state. Fish history normally lives separately in `~/.local/share/fish`.

Rust and Vite+ initialization files belong to their installers and are not bundled here. The development snippet sources them only when present. Do not copy an entire home directory or its installed runtimes from the workstation to the server.

## Verify

Run these in the new fish session:

```fish
# Must produce no startup banner.
fish -c true

# Inspect command resolution when development tools are installed.
type -a node npm pnpm

# Inspect the configured paths.
printf '%s\n' $PATH
```

Check Tab completion, gray suggestions, syntax colors, and the prompt. In a project with a Node version file, verify that changing into the directory selects the expected version with `node --version`. When using Vite+ too, check its project behavior separately.

In an SSH session, `term`, `rterm`, `logoff`, and `agents-edit` should not be defined by this configuration, and pfetch should not run.

## Updating and rollback

Repository edits do not automatically change installed copies. Repeat the backup-and-replace procedure after reviewing an update. Avoid reinstalling duplicate Rust or Vite+ snippets alongside `20-development.fish`.

To roll back, move the newly installed configuration aside, restore the backed-up files, and open a fresh shell. Keep Bash available for Bash scripts and administration. Trying this configuration does not require changing the login shell.
