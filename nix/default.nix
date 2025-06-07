# The default set of nix configuration.
{
  imports =
    [ # import all of the nix files here
      ./packages.nix
      ./dropbox.nix
      ./tmux.nix
      ./zsh.nix
    ];
}
