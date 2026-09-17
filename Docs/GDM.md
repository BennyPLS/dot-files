# Keep Graphite on the login screen

Graphite modifies `/usr/share/gnome-shell/gnome-shell-theme.gresource`, currently shipped by the `gnome-shell` package. Installing or upgrading that package replaces the file. The pacman hook watches the file path rather than a package name, so it rebuilds the theme after any transaction that installs that file, whichever package delivers it. The `gdm` package does not ship it, so gdm updates are not a trigger.

## Install

From this repository, run:

```sh
sudo ./scripts/setup-gdm.sh
```

Or include it during desktop setup with `./scripts/setup-gnome.sh --gdm`. Preview the standalone installer with `./scripts/setup-gdm.sh --dry-run`.

The installer installs build dependencies, installs `/etc/pacman.d/hooks/95-graphite-gdm.hook`, and applies the Nord red dark rimless GDM theme immediately. Graphite is not kept on disk: each rebuild downloads it into a root-owned temporary directory under `/var/lib/graphite-gdm/` and removes it when the build ends. It does not restart GDM or end your session. Inspect the login screen after your next logout or reboot.

## After updates

The hook calls `/usr/local/libexec/graphite-gdm-apply` after a transaction installs or upgrades the theme resource. It clones Graphite from GitHub for that rebuild, so the machine needs network access during the pacman transaction. The build itself runs without network in a private temporary directory through systemd, and the helper saves the previous resource, the package version, and the source commit under `/var/lib/graphite-gdm/`. If the installer or resource validation fails, the helper restores the pre-build resource. It does not restore an older compiled resource over a newly installed GNOME version.

You can reapply manually with:

```sh
sudo /usr/local/libexec/graphite-gdm-apply
```

Every rebuild takes upstream's current main branch, so a Graphite change reaches the login screen on the next `gnome-shell` upgrade. The recorded `source-commit.txt` identifies the commit that produced the installed resource. A resource that compiles is not proof of visual compatibility; check the login screen after major upgrades. After each successful rebuild, cleanup keeps only that newest successful backup and removes the earlier rebuild backups, including failed ones. Failed builds do not trigger cleanup, so their backups stay for review until the next successful rebuild removes them. Installer backups are separate; `setup-gdm.sh` keeps the one from its most recent run. Setup backups under `~/dotfiles-backups/` follow the same keep-the-latest rule.

Rerun `sudo ./scripts/setup-gdm.sh` to install this retention policy if the hook was installed before it was added. That run also removes an earlier install's `/usr/local/share/graphite-gdm` source tree.

## Disable and restore the packaged theme

Remove the hook first, then reinstall GNOME Shell so pacman restores its current resource:

```sh
sudo rm /etc/pacman.d/hooks/95-graphite-gdm.hook
sudo pacman -S gnome-shell
```

This leaves backups and the helper available but stops automatic reapplication. No GDM service restart is needed while working in your session.

References: [Graphite installer](https://github.com/vinceliuice/Graphite-gtk-theme), [Arch pacman hooks](https://man.archlinux.org/man/alpm-hooks.5.en).
