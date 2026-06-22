# Prompt Style
#PROMPT='%F{green}%n@%m%f %F{blue}%1~%f %# '

# Starship prompt
eval "$(starship init zsh)"

# Completion system
autoload -Uz compinit && compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Show all completions immediately
setopt AUTO_LIST
unsetopt LIST_AMBIGUOUS

# History search with arrow keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# fzf shell integration (works on Mac and Linux, requires fzf 0.48.0+)
if [[ -x $(command -v fzf) ]]; then
  eval "$(fzf --zsh)"
fi

# Colors and ls aliases (OS-aware)
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls='ls -G'
  alias ll='ls -alFG'
  alias la='ls -AG'
  alias l='ls -CFG'
else
  if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  fi
  alias ls='ls --color=auto'
  alias ll='ls -alF --color=auto'
  alias la='ls -A --color=auto'
  alias l='ls -CF --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Machine-specific config (not in repo)
source ~/.zshrc.local 2>/dev/null

# Load plugins — zsh-syntax-highlighting must be last
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
