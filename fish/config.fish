# Starship theme
starship init fish | source

# Remove Welcome message
set fish_greeting

# Dart path
set PATH $PATH /opt/flutter/bin/ $HOME/.pub-cache/bin
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
# GPG keys
set -gx GPG_TTY (tty)

# Alias

# ls, tree and cat replacements for the exa, exa --tree and ccat modern versions with extra config.
alias ls='exa -hg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias ll='exa -lhg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias hls='exa --all -hg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias hll='exa --all -lhg --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias tree='exa --tree -hg --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias cat='bat --style plain'
alias bcat='bat'

# Alacritty Terminal Alias
alias term='alacritty & disown'
alias rterm='alacritty & disown | exit'

# Logout GNOME SESSION
alias  logoff='gnome-session-quit --no-prompt --logout'

# Docker service control
alias docker-init='sudo systemctl start docker.service'
alias docker-stop='sudo systemctl stop docker.service'

pfetch
