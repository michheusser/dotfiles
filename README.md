# dotfiles

Managed with GNU Stow.

## Setup on a new machine

Install stow:
- Mac: brew install stow
- Ubuntu: sudo apt install stow

Then:

git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
stow zsh
stow ghostty
stow tmux
stow nvim
