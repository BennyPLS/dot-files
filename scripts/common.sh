#!/usr/bin/env bash
# Shared by the two setup scripts.
set -euo pipefail
REPO=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
DRY_RUN=false
SKIP_PACKAGES=false
BACKUP=
SOURCES=
fail() { printf '%s\n' "$*" >&2; exit 1; }
run() {
    if $DRY_RUN; then printf '  '; printf '%q ' "$@"; printf '\n'; else "$@"; fi
}
backup_init() {
    if $DRY_RUN; then BACKUP="$HOME/dotfiles-backups/preview"; return; fi
    mkdir -p "$HOME/dotfiles-backups"
    # Only the backup from the most recent run is kept.
    find "$HOME/dotfiles-backups" -mindepth 1 -maxdepth 1 -name '????????-??????-??????' -exec rm -rf -- {} +
    BACKUP=$(mktemp -d "$HOME/dotfiles-backups/$(date +%Y%m%d-%H%M%S)-XXXXXX")
    printf 'Backups: %s\n' "$BACKUP"
}
backup() {
    local path=$1 label=$2
    if [[ -e "$path" || -L "$path" ]]; then run cp -a -- "$path" "$BACKUP/$label"; fi
}
replace() {
    local source=$1 target=$2 label=$3
    if $DRY_RUN; then
        printf '  Back up and replace %s with %s\n' "$target" "$source"
        return
    fi
    mkdir -p -- "$(dirname -- "$target")"
    local staged
    staged=$(mktemp -d "$(dirname -- "$target")/.dotfiles-stage-XXXXXX")
    cp -a -- "$source" "$staged/new"
    if [[ -e "$target" || -L "$target" ]]; then mv -- "$target" "$BACKUP/$label"; fi
    mv -- "$staged/new" "$target"
    rmdir -- "$staged"
}
packages() {
    if $SKIP_PACKAGES; then return; fi
    if ! $DRY_RUN; then command -v pacman >/dev/null || fail 'Automatic package installation requires Arch Linux. Use --skip-packages after installing dependencies.'; fi
    run sudo pacman -S --needed "$@"
}
require() {
    if $DRY_RUN; then return; fi
    local cmd
    for cmd in "$@"; do command -v "$cmd" >/dev/null || fail "Missing command: $cmd"; done
}
sources_init() {
    if $DRY_RUN; then SOURCES="${TMPDIR:-/tmp}/dotfiles-sources-preview"; return; fi
    SOURCES=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-sources-XXXXXX")
    # Upstream checkouts exist only for this run.
    trap 'rm -rf -- "$SOURCES"' EXIT
    printf 'Upstream sources: %s (removed when this script exits)\n' "$SOURCES"
}
clone_source() {
    local url=$1 name=$2
    run git clone --depth 1 "$url" "$SOURCES/$name"
}
