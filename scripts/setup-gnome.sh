#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
SKIP_EXTENSIONS=false
SETUP_GDM=false
CURSOR_DIR=
while (($#)); do
    case "$1" in
        --dry-run) DRY_RUN=true ;;
        --gdm) SETUP_GDM=true ;;
        --skip-packages) SKIP_PACKAGES=true ;;
        --skip-extensions) SKIP_EXTENSIONS=true ;;
        --cursor-dir) [[ $# -ge 2 && -d "$2" ]] || fail '--cursor-dir requires an extracted Oreo Spark Red theme directory'; CURSOR_DIR=$(cd -- "$2" && pwd); shift ;;
        --help|-h)
            printf '%s\n' 'Usage: setup-gnome.sh [--gdm] [--skip-packages] [--skip-extensions] [--cursor-dir DIR] [--dry-run]' 'Run inside an existing GNOME session. Installs Graphite, Candy, Oreo, fonts and compatible extensions.' 'Use --cursor-dir for a prebuilt oreo_spark_red_cursors directory; otherwise Oreo is built from source.' 'Downloads upstream sources to a temporary directory and removes them on exit.' 'Backs up affected configuration and records upstream source commits.'
            exit 0 ;;
        *) fail "Unknown option: $1" ;;
    esac
    shift
done
[[ $EUID -ne 0 ]] || fail 'Run as your regular GNOME desktop user.'
# Graphite upstream writes specifically to ~/.config/gtk-4.0.
[[ "$CONFIG_HOME" == "$HOME/.config" ]] || fail 'Graphite requires the default XDG_CONFIG_HOME for this script.'
require gnome-shell gsettings dconf
if ! $DRY_RUN; then
    [[ -n ${DBUS_SESSION_BUS_ADDRESS:-} ]] || fail 'Run this script inside your GNOME desktop session.'
fi
packages git sassc gnome-themes-extra gnome-tweaks ttf-jetbrains-mono-nerd python
if [[ -z "$CURSOR_DIR" && ! -d "$DATA_HOME/icons/oreo_spark_red_cursors/cursors" && ! -d /usr/share/icons/oreo_spark_red_cursors/cursors && ! -d "$HOME/.icons/oreo_spark_red_cursors/cursors" ]]; then
    packages make ruby inkscape xorg-xcursorgen
fi
require git sassc python
backup_init
if ! $DRY_RUN; then
    dconf dump /org/gnome/desktop/interface/ > "$BACKUP/interface.dconf"
    dconf dump /org/gnome/shell/extensions/ > "$BACKUP/extensions.dconf"
    gsettings get org.gnome.shell enabled-extensions > "$BACKUP/enabled-extensions.txt"
fi
sources_init
clone_source https://github.com/vinceliuice/Graphite-gtk-theme.git Graphite-gtk-theme
clone_source https://github.com/EliverLara/candy-icons.git candy-icons
backup "$CONFIG_HOME/gtk-4.0" gtk-4.0
backup "$CONFIG_HOME/gtk-3.0" gtk-3.0
backup "$HOME/.themes/Graphite-red-Dark-nord" Graphite-red-Dark-nord
if ! $DRY_RUN; then
    # Remove only the three paths managed by Graphite, after the backup.
    for name in assets gtk.css gtk-dark.css; do
        target="$CONFIG_HOME/gtk-4.0/$name"
        if [[ -e "$target" || -L "$target" ]]; then mv -- "$target" "$BACKUP/gtk4-original-$name"; fi
    done
fi
run bash "$SOURCES/Graphite-gtk-theme/install.sh" -t red -c dark --tweaks nord rimless -l
replace "$SOURCES/candy-icons" "$DATA_HOME/icons/candy-icons" candy-icons
if [[ -n "$CURSOR_DIR" ]]; then
    [[ -f "$CURSOR_DIR/index.theme" && -d "$CURSOR_DIR/cursors" ]] || fail 'Cursor directory must contain index.theme and cursors/'
    replace "$CURSOR_DIR" "$DATA_HOME/icons/oreo_spark_red_cursors" oreo-cursors
elif [[ -d "$DATA_HOME/icons/oreo_spark_red_cursors/cursors" || -d /usr/share/icons/oreo_spark_red_cursors/cursors || -d "$HOME/.icons/oreo_spark_red_cursors/cursors" ]]; then
    printf '%s\n' 'Using installed Oreo Spark Red cursors.'
else
    clone_source https://github.com/varlesh/oreo-cursors.git oreo-cursors
    require make ruby inkscape xcursorgen
    if $DRY_RUN; then
        printf '  Generate and build Oreo cursors, then install only oreo_spark_red_cursors\n'
    else
        (cd "$SOURCES/oreo-cursors" && ruby generator/convert.rb && make build)
    fi
    replace "$SOURCES/oreo-cursors/dist/oreo_spark_red_cursors" "$DATA_HOME/icons/oreo_spark_red_cursors" oreo-cursors
fi
run gsettings set org.gnome.desktop.interface gtk-theme Graphite-red-Dark-nord
run gsettings set org.gnome.desktop.interface color-scheme prefer-dark
run gsettings set org.gnome.desktop.interface icon-theme candy-icons
run gsettings set org.gnome.desktop.interface cursor-theme oreo_spark_red_cursors
run gsettings set org.gnome.desktop.interface cursor-size 32
run gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font Propo 11'
run gsettings set org.gnome.desktop.interface document-font-name 'JetBrainsMono Nerd Font Propo 11'
run gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 11'
if ! $SKIP_EXTENSIONS; then
    require gnome-extensions
    run python "$REPO/scripts/install-extensions.py" "$REPO" "$BACKUP"
    replace "$REPO/gnome/extensions/gsnap-layouts.json" "$CONFIG_HOME/gSnap/layouts.json" gsnap-layouts.json
fi
if ! $DRY_RUN; then
    for name in Graphite-gtk-theme candy-icons oreo-cursors; do
        if [[ -d "$SOURCES/$name/.git" ]]; then
            printf '%s %s\n' "$name" "$(git -C "$SOURCES/$name" rev-parse HEAD)" >> "$BACKUP/source-commits.txt"
        fi
    done
fi
if $SETUP_GDM; then run sudo "$REPO/scripts/setup-gdm.sh"; fi
$DRY_RUN && { printf '%s\n' 'Dry run complete. No changes made.'; exit 0; }
printf '%s\n' 'GNOME setup complete. Log out and back in, then review extension status and monitor layouts.'
