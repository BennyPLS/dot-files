# Desktop conveniences are excluded from SSH and headless sessions.
status is-interactive; or return
set -q SSH_CONNECTION; and return
if not set -q DISPLAY; and not set -q WAYLAND_DISPLAY
    return
end

if type -q ghostty
    function term --description 'Open Ghostty'
        ghostty $argv &
        disown
    end
    function rterm --description 'Open Ghostty and leave this shell'
        term $argv
        and exit
    end
end
if type -q gnome-session-quit
    alias logoff='gnome-session-quit --no-prompt --logout'
end
if type -q zeditor
    alias agents-edit='zeditor -n ~/.claude/CLAUDE.md ~/.codex/AGENTS.md'
end
if type -q pfetch
    pfetch
end
