# Starship theme
starship init fish | source

# Alias

# ls, tree and cat replacements for the exa, exa --tree and ccat modern versions with extra config.

alias ls='exa -hg --grid --group-directories-first --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'

alias ll='exa -lhg --grid --group-directories-first --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'

alias hls='exa --all -hg --group-directories-first --grid --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'

alias hll='exa --all -lhg --grid --group-directories-first --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'

alias dls='ls | grep '''

alias tree='exa --tree -hg --time-style=long-iso --ignore-glob="System Volume Information|?RECYCLE.BIN" --icons --git'
alias cat='ccat -G Keyword=teal -G Literal=brown -G Decimal=brown -G Plaintext=drakblue'
alias killmyself='shutdown now'

# Alacritty Terminal Alias
alias term='alacritty & disown'
alias rterm='alacritty & disown | exit'

# Aseprite
alias aseprite='/Personal/Programacion/Unity/Herramientas\ Para\ GameMaking/Aseprite/Aseprite.exe & disown'

set DOTNET_CLI_TELEMETRY_OPTOUT 0

if status is-interactive
    # Commands to run in interactive sessions can go here
end

pfetch
