# Environment

- Shell is zsh. Terminal is ghostty. Editor is nvim. Prompt is starship. Multiplexer is tmux.
- Dotfiles live at `~/dotfiles`, managed with GNU Stow. Packages: `bash`, `zsh`, `nvim`, `tmux`, `ghostty`, `starship`, `claude`.
- The Claude Code configuration is stowed. `~/.claude/settings.json`, `CLAUDE.md`, `keybindings.json`, `output-styles/`, `rules/`, `skills/`, `agents/`, `commands/`, and `plugins/known_marketplaces.json` are all symlinks into `~/dotfiles/claude/.claude/`.
- IMPORTANT: writes to Claude configuration must target `~/dotfiles/claude/.claude/…`. Writing to the `~/.claude/…` path fails with "refusing to write through symlink".
- `~/.claude/settings.local.json` is a real file, not stowed. It holds machine-specific permissions.
- I run my own git commits and pushes. Both are in the settings deny list.
