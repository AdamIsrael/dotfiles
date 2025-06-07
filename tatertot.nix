# A flake for managing MacOS configurations
#
{ config, pkgs, nix-your-shell, ... }:
{
  nixpkgs.overlays = [
    nix-your-shell.overlays.default
  ];
  environment.systemPackages = [
    pkgs.nix-your-shell
  ];

}
