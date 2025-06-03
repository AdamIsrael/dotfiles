

default:
  @just --list

# symlink dotfiles
symlink:
    @ln -sf `pwd`/justfile ~/justfile
    @ln -sf `pwd`/gitconfig ~/.gitconfig

# Apply nix system configuration
nix-switch:
    #!/usr/bin/env bash
    if [ -e /etc/NIXOS ]; then
        sudo cp ~/.dotfiles/nixos/configuration.nix /etc/nixos
        sudo nixos-rebuild switch
    else
        sudo darwin-rebuild switch --flake /Users/adam/.dotfiles#tatertot
    fi
