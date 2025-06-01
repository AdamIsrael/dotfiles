{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew on nix-darwin
    # https://github.com/zhaofengli/nix-homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, homebrew-core, homebrew-cask,... }:
  let
    configuration = { pkgs, ... }: {

      environment.etc.nix-darwin.source = "/Users/adam/.dotfiles";

      system.primaryUser = "Adam Israel";

      nixpkgs.config.allowUnfree = true;

      # Disable nix-darwin's management of the Nix installation
      # since Determinate uses its own daemon to manage Nix.
      nix.enable = false;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          # Search tools
          pkgs.ripgrep
          pkgs.silver-searcher

          # Blog stuff
          pkgs.hugo

          # Nix language server
          pkgs.nil
          pkgs.nixd

          # Image tools
          pkgs.imagemagick

          # Text editor
          pkgs.neovim

          # Terminal multiplexer
          pkgs.tmux

          # Other terminal stuff
          # pkgs.humanlog
          pkgs.direnv
          pkgs.curl

          # Git stuff
          pkgs.git
          pkgs.pre-commit

          # Misc stuff
          # pkgs.telnet
          pkgs.tree
          pkgs.watch
          pkgs.glow
        ];

        homebrew = {
          enable = true;

          taps = [];

          brews = [
            # "glow"
            "humanlog"
            "jq"
            "pandoc"
            "starship"
            "telnet"
            # "tree"
            # "watch"
          ];

          casks = [
            # Audio
            "audacity"

            # Ebooks
            "calibre"

            # Image manipulation
            "gimp"
            "inkscape"

            # Personal Info Management
            "obsidian"

            # Browsers
            "google-chrome"
            "firefox"
            "tor-browser"

            # Password management
            "1password"

            # Terminal stuff
            "ghostty"

            # Database front-ends
            "mysqlworkbench"
            "pgadmin4"
          ];

        };
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;
      # programs.zsh.initExtra = ''
      #       # Setup the brew package manager for GUI apps
      #       eval "$(/opt/homebrew/bin/brew shellenv)"

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Add ability to used TouchID for sudo authentication
      security.pam.services.sudo_local.touchIdAuth = true;

      users.users.adam.shell = pkgs.zsh;
      users.knownUsers = [ "adam" ];
      users.users.adam.uid = 501;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#tatertot
    darwinConfigurations."tatertot" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration

        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            enable = true;

            # Rosetta support seems broken on Apple Silicon
            # ln: /usr/local/Homebrew/Library/Homebrew: No such file or directory
            enableRosetta = false;
            user = "adam";

            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
            mutableTaps = false;
          };
        }
      ];
    };
  };
}
