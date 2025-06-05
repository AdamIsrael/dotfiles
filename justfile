

default:
  @just --list

# symlink dotfiles
symlink:
    #@ln -sf ~/.dotfiles/justfile ~/justfile
    @ln -sf ~/.dotfiles/gitconfig ~/.gitconfig
    @ln -sf ~/.dotfiles/config/hypr ~/.config/hypr
    @ln -sf ~/.dotfiles/config/waybar ~/.config/waybar
    @ln -sf ~/.dotfiles/ssh/config ~/.ssh/config
    @ln -sf ~/.dotfiles/zshrc ~/.zshrc

# Apply nix system configuration
nix-switch:
    #!/usr/bin/env bash
    if [ -e /etc/NIXOS ]; then
        sudo cp ~/.dotfiles/nixos/configuration.nix /etc/nixos
        sudo nixos-rebuild switch
    else
        sudo darwin-rebuild switch --flake /Users/adam/.dotfiles#tatertot
    fi
