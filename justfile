

default:
  @just --list

# symlink dotfiles
symlink:
    @ln -sf justfile ~/justfile

# Apply nix system configuration
nix-switch:
    @sudo darwin-rebuild switch --flake /Users/adam/.dotfiles#tatertot
