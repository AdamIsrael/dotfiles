{ pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    rust-petname

    # Applets
    blueman
    networkmanagerapplet

    # Control the screen brightness
    brightnessctl

    # Sound
    # alsa-utils

    # Rofi
    rofi
    rofi-network-manager

    # Notification daemon
    # dunst
    mako
    libnotify

    gnome-themes-extra
    xdg-desktop-portal-hyprland
    # xdg-desktop-portal-gtk

    # hyprland-related packages
    waybar
    hyprpaper
    hypridle
    hyprlock

    # Some matrix-style terminal effects
    cmatrix
    tmatrix
    unimatrix

    # app launcher
    wofi

    # Terminals
    kitty
    ghostty
    starship

    # git
    just
    zed-editor
    # powerline-fonts
    killall
    pavucontrol
    kdePackages.dolphin

    # Search tools
    ripgrep
    silver-searcher

    # Blog stuff
    hugo

    # Nix language server
    nil
    nixd

    # Image tools
    imagemagick

    # Text editor
    vim
    neovim

    # Terminal multiplexer
    tmux

    # Other terminal stuff
    # pkgs.humanlog
    direnv
    curl
    wget

    # Git stuff
    git
    pre-commit

    # Misc stuff
    tree
    watch
    glow
    jq
    dropbox-cli
    neofetch

    # Fingerprint reader
    fprintd

    # Social Media
    slack
    discord
    hexchat

    # PIM
    obsidian

  ];
}
