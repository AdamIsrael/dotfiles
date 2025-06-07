{ pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnome-themes-extra
    xdg-desktop-portal-hyprland
    # xdg-desktop-portal-gtk
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    waybar
    hyprpaper
    hypridle
    hyprlock

    # Some matrix-style terminal effects
    cmatrix
    tmatrix
    unimatrix

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
