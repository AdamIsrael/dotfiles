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

## Waybar

Sometimes, Waybar will fail to load or take ~30 seconds to start.

This seems to be a first boot issue, or after logging into GNOME and back to hyprland. There's a potential fix in `start.sh` but it needs more testing to figure out why.

If it does timeout calling StartServiceByName, wait a minute and try again. _Something_ is starting up in the background, apparently.

This may be fixed now? I added `systemctl --user start xdg-desktop-portal` to `start.sh` to make sure xdg-desktop-portal is available, and I did a reboot and it started up fine the first time.

## TODO

- Notification daemon
- ~~auto-exclude folders from Dropbox for smaller footprint/faster sync~~
- ~~fix tmux plugins~~
- ~~split nixos/configuration.nix into separate files~~
  - ~~apps should install from a separate nix and be shared w/ `flake.nix`~~
- ~~install tailscale~~
  - ~~write script/justfile/alias to connect/disconnect~~
- ~~install/configure bluetooth~~
- figure out sync for Obsidian vaults. Can I use Dropbox btw MacOS/Linux or sign up for their sync
- get the fn keys to work (volume, mic, brightness, bluetooth)
- `gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"`
- automatically turn on keyboard backlighting
- setup podman
- modify setup script to use https/no ssh key
- add just target to swap repository from https to ssh
