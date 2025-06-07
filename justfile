

default:
  @just --list

# symlink dotfiles
symlink:
    @ln -sf ~/.dotfiles/aliases ~/.aliases
    @ln -sf ~/.dotfiles/gitconfig ~/.gitconfig
    @ln -sf ~/.dotfiles/justfile ~/justfile
    @ln -sf ~/.dotfiles/config/hypr ~/.config/hypr
    @ln -sf ~/.dotfiles/config/waybar ~/.config/waybar
    @ln -sf ~/.dotfiles/ssh/config ~/.ssh/config
    @ln -sf ~/.dotfiles/tmux.conf ~/.tmux.conf
    @ln -sf ~/.dotfiles/vimrc ~/.vimrc
    @ln -sf ~/.dotfiles/zshrc ~/.zshrc

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
