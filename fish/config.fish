# Starship theme
starship init fish | source

# Alias

# ls, tree and cat replacements for the exa, exa --tree and ccat modern versions with extra config.
alias ls='exa -hg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias ll='exa -lhg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias hls='exa --all -hg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias hll='exa --all -lhg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias tree='exa --tree -hg --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias cat='ccat'

# Alacritty Terminal Alias
alias term='alacritty & disown'
alias rterm='alacritty & disown | exit'

# Logout GNOME SESSION
alias  logoff='gnome-session-quit --no-prompt --logout'

# DOTFILES Variable
set DOTFILES "/Personal/dot-files"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

pfetch
