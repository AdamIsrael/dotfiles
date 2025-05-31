{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      environment.etc.nix-darwin.source = "/Users/adam/.dotfiles";

      system.primaryUser = "Adam Israel";

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

          # Nix language server
          pkgs.nil
          pkgs.nixd

          # Text editor
          pkgs.neovim
          # Terminal multiplexer
          pkgs.tmux
          # Git stuff
          pkgs.git
          pkgs.pre-commit
        ];

        homebrew = {
          enable = true;
          casks = [
            # Personal Info Management
            "obsidian"

            # Browsers
            "google-chrome"
            "firefox"

            # Password management
            "1password"
          ];
        };
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

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
      modules = [ configuration ];
    };
  };
}
