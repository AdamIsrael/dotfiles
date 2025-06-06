# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stone = {
    isNormalUser = true;
    description = "Adam Israel";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        #"z"
      ];
      theme = "robbyrussell";
    };

    shellAliases = {
      ll = "ls -l";
      # edit = "sudo -e";
      update = "sudo nixos-rebuild switch";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g status-right "%H:%M"
      set -g window-status-current-style "underscore"

      # If running inside tmux ($TMUX is set), then change the status line to red
      %if #{TMUX}
      set -g status-bg red
      %endif

      # Enable RGB colour if running in xterm(1)
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Change the default $TERM to tmux-256color
      set -g default-terminal "tmux-256color"

      # Set pane border
      set -g pane-active-border-style "fg=#7aa2f7"
      set -g pane-border-style "fg=#444b6a"


      # No bells at all
      set -g bell-action none

      # Change the prefix key to C-a
      set -g prefix C-a
      unbind C-b
      bind C-a send-prefix

      # force a reload of the config file
      unbind r
      bind r source-file ~/.tmux.conf

      # Turn the mouse on, but without copy mode dragging
      set -g mouse on

      # Allow shift-arrow to navigate panes
      bind -n S-Left  select-pane -L
      bind -n S-Right select-pane -R
      bind -n S-Up    select-pane -U
      bind -n S-Down  select-pane -D

      # Allow meta-arrow to navigate windows
      bind -n M-Left  previous-window
      bind -n M-Right next-window

      # Setup tmux plugin manager
      set -g @plugin 'tmux-plugins/tpm'

      set -g @plugin 'tmux-plugins/tmux-pain-control'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'tmux-plugins/tmux-logging'

      # Set theme - dracula
      # See options here: https://draculatheme.com/tmux
      set -g @plugin 'dracula/tmux'

      # available plugins: battery, cpu-usage, git, gpu-usage, ram-usage,
      # tmux-ram-usage, network, network-bandwidth, network-ping, ssh-session,
      # attached-clients, network-vpn, weather, time, mpc, spotify-tui,
      # playerctl, kubernetes-context, synchronize-panes
      set -g @dracula-plugins "kubernetes-context cpu-usage ram-usage time"

      # Enable powerline glyphs
      set -g @dracula-show-powerline true

      # A faster refresh is nice, but may have performance impact (5)
      set -g @dracula-refresh-rate 5

      # `hostname` (full hostname), `session`, `shortname` (short name),
      # `smiley`, `window`, or any character.
      set -g @dracula-show-left-icon shortname

      # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
      run '~/.tmux/plugins/tpm/tpm'

      # ...
      # set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
      # run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Flat-Remix-Red-Dark";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono Medium 11";
      };
    }
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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

  # Fingerprint reader
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Enables the 1Password CLI
  programs._1password = { enable = true; };

  # Enables the 1Password desktop app
  programs._1password-gui = {
    enable = true;
    # this makes system auth etc. work properly
    polkitPolicyOwners = [ "stone" ];
  };

  # Set the default editor to vim
  environment.variables.EDITOR = "nvim";

  # Fonts
  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
    # (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    #nerd-fonts.NerdFontsSymbolsOnly
  ];
  #fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues znerd-fonts)

  #environment.kdePackages = with pkgs; [
  #  dolphin
  #];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable dropbox service
  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${lib.getBin pkgs.dropbox}/bin/dropbox";
      ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
