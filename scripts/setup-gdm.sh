#!/usr/bin/env bash
set -euo pipefail
REPO=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
case "${1:-}" in
    --help|-h) echo 'Usage: sudo ./scripts/setup-gdm.sh [--dry-run]'; exit 0 ;;
    --dry-run)
        echo 'Install build dependencies, install the pacman hook, and apply the GDM theme.'
        echo 'Each rebuild downloads Graphite into a temporary directory and removes it afterwards.'
        echo 'No GDM restart. No login-session changes. Managed files are backed up, replacing the previous installer backup.'
        exit 0 ;;
    '') ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
esac
[[ $# -eq 0 ]] || exit 1
[[ $EUID -eq 0 ]] || { echo 'Run with sudo to install the system GDM hook.' >&2; exit 1; }
export PATH=/usr/bin:/bin
[[ -f /usr/share/gnome-shell/gnome-shell-theme.gresource ]] || { echo 'GNOME Shell resource not found.' >&2; exit 1; }
pacman -S --needed git sassc glib2 python-gobject
install -d -m 755 /usr/local/libexec /etc/pacman.d/hooks
install -d -m 700 /var/lib/graphite-gdm
# Only the backup from the most recent installer run is kept.
find /var/lib/graphite-gdm -mindepth 1 -maxdepth 1 -name 'install-backup-*' -exec rm -rf -- {} +
backup=$(mktemp -d /var/lib/graphite-gdm/install-backup-XXXXXX)
# The helper downloads its own source for each rebuild; drop any checkout an earlier install kept.
rm -rf -- /usr/local/share/graphite-gdm
for target in /usr/local/libexec/graphite-gdm-apply /usr/local/libexec/graphite-gdm-prune.py /etc/pacman.d/hooks/95-graphite-gdm.hook; do
    if [[ -e "$target" ]]; then cp -a "$target" "$backup/"; fi
done
install -o root -g root -m 755 "$REPO/gnome/gdm/graphite-gdm-apply" /usr/local/libexec/graphite-gdm-apply
install -o root -g root -m 644 "$REPO/gnome/gdm/graphite-gdm-prune.py" /usr/local/libexec/graphite-gdm-prune.py
install -o root -g root -m 644 "$REPO/gnome/gdm/95-graphite-gdm.hook" /etc/pacman.d/hooks/95-graphite-gdm.hook
/usr/local/libexec/graphite-gdm-apply
echo "GDM theme and pacman hook installed. Installer backup: $backup"
