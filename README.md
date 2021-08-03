# Dotfiles

Dotfiles to be symlinked to ~


# Initializing

Rough cut:

On OS X:

```bash
brew install gnupg
brew install desk
```

```bash
# Clone dotfiles locally
git clone https://github.com/AdamIsrael/dotfiles.git ~/.dotfiles

# Initialize the submodules
cd ~/.dotfiles/zsh/plugins
git submodule update --init

```