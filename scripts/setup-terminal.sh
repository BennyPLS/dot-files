#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
SERVER=false
LOGIN_SHELL=false
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --skip-packages) SKIP_PACKAGES=true ;;
        --server) SERVER=true ;;
        --login-shell) LOGIN_SHELL=true ;;
        --help|-h)
            printf '%s\n' 'Usage: setup-terminal.sh [--server] [--skip-packages] [--login-shell] [--dry-run]' 'Installs Fish, Starship, Eza, Bat and fzf, plus Ghostty and fonts on a workstation.' 'Copies the repository configuration after backing up existing files.' 'Development runtimes and pfetch are optional and installed separately.'
            exit 0 ;;
        *) fail "Unknown option: $arg" ;;
    esac
done
[[ $EUID -ne 0 ]] || fail 'Run as your regular user. The script uses sudo only for packages.'
packages fish starship eza bat fzf
if ! $SERVER; then packages ghostty ttf-jetbrains-mono-nerd; fi
require fish
if ! $DRY_RUN; then
    while IFS= read -r -d '' file; do fish --no-config --no-execute "$file"; done < <(find "$REPO/fish" -name '*.fish' -print0)
fi
backup_init
replace "$REPO/fish" "$CONFIG_HOME/fish" fish
replace "$REPO/starship.toml" "$CONFIG_HOME/starship.toml" starship.toml
if $LOGIN_SHELL; then
    if $DRY_RUN; then printf '  Set the login shell to the installed fish executable\n'; else chsh -s "$(command -v fish)"; fi
fi
$DRY_RUN && { printf '%s\n' 'Dry run complete. No changes made.'; exit 0; }
printf '%s\n' 'Terminal setup complete. Open a new fish session to use it.'
