# Dotfiles

Dotfiles to be symlinked to ~


## Installation

### Pre-requisites

#### MacOS

```shell
brew install gnupg
```

### Initialization

```shell
# Clone dotfiles locally
git clone https://github.com/AdamIsrael/dotfiles.git ~/.dotfiles

# Initialize the submodules
cd ~/.dotfiles/zsh/plugins
git submodule update --init
```

### Symlink the dotfiles we want to use

```shell
cd ~
rm ~/.aliases || true && ln -s ~/.dotfiles/aliases ~/.aliases
rm ~/.gitconfig || true && ln -s ~/.dotfiles/gitconfig ~/.gitconfig
rm ~/.zshrc || true && ln -s ~/.dotfiles/zshrc ~/.zshrc
rm ~/.tmux.conf || true && ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
rm ~/.vimrc || true && ln -s ~/.dotfiles/vimrc ~/.vimrc
```

### tmux

```shell
tmux new
# Install tmux plugins
control-a, I
```
