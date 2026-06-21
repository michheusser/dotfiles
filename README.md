# dotfiles

Managed with GNU Stow.

## Dependencies

### Mac
brew install stow

### Ubuntu
sudo apt install stow

## Zsh plugins (both machines)
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

## Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## Setup on a new machine
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
stow zsh
stow ghostty
stow tmux
stow nvim

## Machine-specific config

Create ~/.zshrc.local on each machine for anything not shared across machines.

### Mac example (~/.zshrc.local)
export OPENSSL_ROOT_DIR=/opt/homebrew/opt/openssl@3
