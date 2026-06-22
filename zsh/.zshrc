# Prompt Style
PROMPT='%F{green}%n@%m%f %F{blue}%1~%f %# '

# Completion system — must be initialized before zstyle settings take effect
autoload -Uz compinit && compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Show all completions immediately
setopt AUTO_LIST
unsetopt LIST_AMBIGUOUS

# History search with arrow keys
# Uses terminfo for terminal-independence, with guards in case terminfo is unavailable
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh

# Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Machine-specific config (not in repo)
source ~/.zshrc.local 2>/dev/null

# Load plugins — zsh-syntax-highlighting must be last
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
