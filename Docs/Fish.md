# Fish

## Startup and completion

Fish loads the numbered `conf.d` snippets before `config.fish`. The theme applies only to interactive sessions. Development environment setup follows, then desktop conveniences. Finally, `config.fish` adds `~/.local/bin` and initializes interactive aliases and Starship.

Suggestions, syntax highlighting, and the completion interface come from Fish. The theme changes their colors, not their completion logic. Tool-specific completions can also come from installed packages or tool initialization. There is no completion plugin framework in this repository, and `fish_plugins` is empty.

## Commands

Aliases are defined only when the corresponding tool is available.

| Command | Behavior |
| --- | --- |
| `ls`, `ll` | Eza grid or long listing, with icons and Git information |
| `hls`, `hll` | Corresponding listings including hidden files |
| `tree` | Eza tree listing |
| `cat`, `bcat` | Bat with plain styling, or default Bat styling |
| `claude` | Existing personal alias adding `--dangerously-skip-permissions`; bypasses Claude permission prompts |
| `term` | Local desktop only: launch Ghostty with the current display environment, then disown it |
| `rterm` | Run `term`, then exit the shell if it succeeds |
| `logoff` | Local desktop only: request GNOME logout without prompting |
| `agents-edit` | Local desktop only: open `.claude/CLAUDE.md` and `.codex/AGENTS.md` relative to the current directory in Zed |

The `towebp` file is a retained legacy script, not a `.fish` autoload function. It uses cwebp and a shell pipeline; it is not activated at startup.

## Development tools

- Rust: source `~/.cargo/env.fish` if present, including in noninteractive shells.
- pnpm: export `PNPM_HOME` as `~/.local/share/pnpm` and add its `bin` directory with `fish_add_path`; nonexistent directories are not added.
- Vite+: source `~/.config/vite-plus/env.fish` when present in an interactive shell.
- fnm: initialize with `--use-on-cd --shell fish` in interactive shells when available. It runs after Vite+ so its selected Node executables take precedence at initialization.
- Local commands: add `~/.local/bin` through `fish_add_path --global`.

The old fish-nvm/Bass plugins, Node command wrappers, and nvm completion have been removed. Do not restore them over fnm. If Node resolves unexpectedly, use `type -a node npm pnpm`, inspect PATH, and check for leftover functions or duplicate installer snippets. Service processes must use explicitly configured runtimes rather than depend on fnm's interactive hook.

## Customization

Edit `conf.d/10-theme.fish` for colors. Edit `config.fish` for common aliases and `conf.d/30-desktop.fish` for desktop behavior. The desktop banner is optional: remove its pfetch block if unwanted. Remove the personal Claude alias if permission bypass is not appropriate for that machine.

`fish_variables` and `fish_history` are ignored by Git. Store reproducible settings explicitly in configuration rather than copying generated state between machines.
