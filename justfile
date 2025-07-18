

default:
  @just --list

# Install rust
install-rust:
    @curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install the Dropbox daemon
install-dropbox:
    # I originally wrote a bunch of code to start dropbox via systemd, but then we
    # don't get a tray icon, so instead I'll auto-start it as part of the hyperland startup.
    #!/bin/bash
    dropbox start -i
    echo "Dropbox daemon is installing!"
    echo "Once Dropbox has begun syncing, run 'bin/dropbox-exclude.sh' to limit the folders to sync."

# Setup bluefin by install/removing/configuring flatpaks
setup-bluefin:
    #!/bin/bash
    set -eux

    # Flatpak(s) to remove
    flatpaks="org.mozilla.firefox"
    for flatpak in $flatpaks ; do
        if flatpak info "${flatpak}" >/dev/null 2>&1; then
            flatpak remove -y "${flatpak}"
        fi
    done

    # install flatpak(s)
    flatpaks=(
        "com.discordapp.Discord"
        "org.squidowl.halloy"
        "com.slack.Slack"
        "md.obsidian.Obsidian"
    )
    for flatpak in $flatpaks ; do
        if ! flatpak info "${flatpak}" >/dev/null; then
            flatpak install -y --noninteractive "${flatpak}"
        fi
    done

    # Install brew package(s)
    brew install humanlog

# Install zed
install-zed:
    #!/bin/bash
    if [ ! -f ~/.local/bin/zed ]; then
        curl -f https://zed.dev/install.sh | sh
    fi

# symlink dotfiles
symlink:
    @ln -sf ~/.dotfiles/aliases ~/.aliases
    @ln -sf ~/.dotfiles/gitconfig ~/.gitconfig
    @ln -sf ~/.dotfiles/justfile ~/justfile
    @ln -sf ~/.dotfiles/config/hypr ~/.config/hypr
    @ln -sf ~/.dotfiles/config/waybar ~/.config/waybar
    @ln -sf ~/.dotfiles/ssh/config ~/.ssh/config
    @ln -sf ~/.dotfiles/config/hexchat ~/.config/hexchat
    @ln -sf ~/.dotfiles/tmux.conf ~/.tmux.conf
    @ln -sf ~/.dotfiles/vimrc ~/.vimrc
    @ln -sf ~/.dotfiles/zshrc ~/.zshrc
    @ln -sf ~/.dotfiles/config/rofi ~/.config/rofi
    @ln -sf ~/.dotfiles/config/mako ~/.config/mako

# hexchat
setup-hexchat:
    op document get Hexchat-servlist.conf > ~/.dotfiles/config/hexchat/servlist.conf
    op document get Hexchat-chanopt.conf > ~/.dotfiles/config/hexchat/chanopt.conf

# Join my iPhone hotspot
wifi-join-hotspot:
    #!/usr/bin/env bash
    source ~/.secrets
    # TODO: fail or prompt if IPHONE_WIFI_PASSWORD isn't set.
    nmcli device wifi connect "Adam’s iPhone" password $IPHONE_WIFI_PASSWORD

wifi-disconnect:
    @nmcli device disconnect wlp0s20f3

# Login to tailscale (will disconnect a connected session)
tailscale-login:
    @sudo tailscale login

# I'm not sure about this yet. Every NixOS host using these dotfiles will be named 'nixos'
# so a random name might be better?
# Randomize the hostname. Warning: this may cause some things (like tailscale) to break.
randomize-hostname:
    #!/usr/bin/env bash
    HOSTNAME=$(petname)
    sed -i -e "s/networking.hostName = \".*\";/networking.hostName = \"${HOSTNAME}\";/g" ~/.dotfiles/nixos/configuration.nix
    # immediately change the hostname
    sudo hostname ${HOSTNAME}
    echo "Your new hostname is '${HOSTNAME}'. Run \`just nix-switch\` to commit this change."

# Install tmux plugin manager (tpm)
tmux-plugin-manager:
    #!/usr/bin/env bash
    if [ -e ~/.tmux/plugins/tpm ]; then
        pushd ~/.tmux/plugins/tpm > /dev/null
        git pull > /dev/null
        popd > /dev/null
        echo "tpm updated! Run <prefix>-u to update plugins."
    else
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm > /dev/null
        echo "tpm installed! Run <prefix>-i to install plugins."
    fi

# Apply nix system configuration
nix-switch:
    #!/usr/bin/env bash
    if [ -e /etc/NIXOS ]; then
        sudo cp ~/.dotfiles/nixos/configuration.nix /etc/nixos
        sudo nixos-rebuild switch
    else
        sudo darwin-rebuild switch --flake /Users/adam/.dotfiles#tatertot
    fi

# Switch the remote from https to ssh
use-git-ssh:
    @git remote set-url origin ssh://git@github.com/adamisrael/dotfiles.git
