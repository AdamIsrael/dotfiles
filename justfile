

default:
  @just --list

# Install the Dropbox daemon
install-dropbox:
    #!/bin/bash
    dropbox start -i
    echo "Dropbox daemon is installing! Run 'just setup-dropbox' when it has finished."

setup-dropbox:
    #!/bin/bash
    # The first time we run this, we need to run start w/ -i to install the dropbox binary
    if pidof dropbox >/dev/null; then
        dropbox stop

        # Gracefully wait for dropbox to stop
        while ! dropbox status | grep -q "Dropbox isn't running!"; do
            sleep 1
        done
        if pidof dropbox >/dev/null; then
            echo "Couldn't stop dropbox. Stop it manually and try again."
            exit 1
        fi
    fi

    # autostart only works on Ubuntu, so create a systemd unit for dropbox
    if [ ! -d ~/.config/systemd/user ]; then
        mkdir -p ~/.config/systemd/user
    fi

    cat > ~/.config/systemd/user/dropbox.service << EOF
    [Unit]
    Description=Dropbox as a user service
    After=local-fs.target network.target

    [Service]
    Type=simple
    ExecStart=%h/.dropbox-dist/dropboxd
    Restart=on-failure
    RestartSec=1

    [Install]
    WantedBy=default.target
    EOF

    # Start & enable the service
    systemctl --user enable dropbox
    systemctl --user start dropbox

    echo "Dropbox started via systemd. Check 'dropbox status' for sync status."
    echo "Once Dropbox has begun syncing, run 'bin/dropbox-exclude.sh' to limit the folders to sync."

# Setup bluefin by install/removing/configuring flatpaks
setup-bluefin:
    #!/bin/bash
    set -eux

    # Remove the firefox flatpak since we're layering it
    if [ -f /usr/sbin/firefox ]; then
        appid=org.mozilla.firefox
        if flatpak info "${appid}" >/dev/null 2>&1; then
            flatpak remove -y "${appid}"
        fi
    fi

    # install flatpak(s)
    flatpaks="halloy slack"
    for flatpak in $flatpaks ; do
        flatpak install -y "${flatpak}"
    done


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
