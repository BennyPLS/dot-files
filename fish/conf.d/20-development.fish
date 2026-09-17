# Tool installers own these files; missing tools are optional.
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end

set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path --global "$PNPM_HOME/bin"

if status is-interactive
    if test -f "$HOME/.config/vite-plus/env.fish"
        source "$HOME/.config/vite-plus/env.fish"
    end
    # Initialize after Vite+ so fnm controls ordinary node/npm commands.
    if type -q fnm
        fnm env --use-on-cd --shell fish | source
    end
end
