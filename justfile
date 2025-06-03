

default:
  @just --list

# symlink dotfiles
symlink:
    @ln -sf `pwd`/justfile ~/justfile
    @ln -sf `pwd`/gitconfig ~/.gitconfig

# Apply nix system configuration
nix-switch:
    @sudo darwin-rebuild switch --flake /Users/adam/.dotfiles#tatertot
