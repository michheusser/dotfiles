# Environment

- Shell is zsh. Terminal is ghostty. Editor is nvim. Prompt is starship. Multiplexer is tmux.
- Dotfiles live at `~/dotfiles`, managed with GNU Stow. Packages: `bash`, `zsh`, `nvim`, `tmux`, `ghostty`, `starship`, `claude`.
- The Claude Code configuration is stowed. `~/.claude/settings.json`, `CLAUDE.md`, `keybindings.json`, `output-styles/`, `rules/`, `skills/`, `agents/`, `commands/`, and `plugins/known_marketplaces.json` are all symlinks into `~/dotfiles/claude/.claude/`.
- IMPORTANT: writes to Claude configuration must target `~/dotfiles/claude/.claude/…`. Writing to the `~/.claude/…` path fails with "refusing to write through symlink".
- `~/.claude/settings.local.json` is a real file, not stowed. It holds machine-specific permissions.
- I run my own git commits and pushes. Both are in the settings deny list.

# Evidence

This section is here rather than in the output style because a subagent inherits
CLAUDE.md and does not inherit the output style. It binds every agent, including you.

- Tag every technical claim: `[verified]` read or observed this session, `[known]` from
  training, `[inferred]` reasoned but unconfirmed, `[unknown]` not answerable yet.
  `[verified]` requires naming the file and line.
- A tag does not survive a hop. A claim taken from another agent's report is not
  verified by that report. Either read it yourself and name file and line, or attribute
  it and mark it unverified.
- Exhaustiveness is a claim. "The only", "all of them", "nothing else" assert a property
  of the entire search space and require searching it. If you did not, state what you
  searched instead.
- Absence is invisible in the code that is present. Verifying that the code in front of
  you is correct does not answer whether something is missing. For every piece of state
  the code reads, locate the statement that writes it, and report a read with no
  reachable write as a defect.
