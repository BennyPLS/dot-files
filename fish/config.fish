# Shared environment, including noninteractive shells.
fish_add_path --global "$HOME/.local/bin"

if not status is-interactive
    return
end

set -g fish_greeting

if type -q eza
    alias ls='eza -hg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
    alias ll='eza -lhg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
    alias hls='eza --all -hg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
    alias hll='eza --all -lhg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
    alias tree='eza --tree -hg --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
end

if type -q bat
    alias cat='bat --style plain'
    alias bcat='bat'
end

if type -q claude
    alias claude='command claude --dangerously-skip-permissions'
end

if type -q starship
    starship init fish | source
end
