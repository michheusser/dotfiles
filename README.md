# dotfiles

Managed with GNU Stow.

## First step: set zsh as default shell

```bash
chsh -s $(which zsh)
```

Log out and back in for this to take effect. If you need a bash session for bash-specific scripts or environments, run `bash` — it will load `.bashrc` as an interactive non-login shell.

## Dependencies

### Mac

```bash
brew install stow
```

### Ubuntu

```bash
sudo apt install stow
```

## Zsh plugins (both machines)

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
```

## Starship

Mac:
```bash
brew install starship
```

Ubuntu (requires confirmation during install):
```bash
curl -sS https://starship.rs/install.sh | sh
```

## direnv (optional — only if used)

Mac:
```bash
brew install direnv
```

Ubuntu:
```bash
sudo apt install direnv
```

## Tmux plugins

```bash
# Plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Catppuccin theme (manual install — TPM has naming conflicts with this repo)
git clone -b v2.3.0 https://github.com/catppuccin/tmux.git ~/.tmux/plugins/catppuccin/tmux
```

After starting tmux, press `Ctrl+b` then `Shift+i` to install remaining plugins (tmux-yank, tmux-cpu).

## Setup on a new machine

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
stow zsh
stow ghostty
stow tmux
stow nvim
stow starship
```

## Machine-specific config

Create `~/.zshrc.local` on each machine for anything not shared across machines.

### Mac example (~/.zshrc.local)

```bash
export OPENSSL_ROOT_DIR=/opt/homebrew/opt/openssl@3
```
