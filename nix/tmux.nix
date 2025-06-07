# My tmux configuration via nix
{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 0;
    terminal = "screen-256color";

    shortcut = "a";
    newSession = true;

    plugins = with pkgs; [
      tmuxPlugins.pain-control
      tmuxPlugins.sensible
      tmuxPlugins.logging
      tmuxPlugins.dracula
    ];

    extraConfig = ''
      # use zsh
      set -g default-shell "${pkgs.zsh}/bin/zsh"

      set -g status-right "%H:%fM"
      set -g window-status-current-style "underscore"

      # If running inside tmux ($TMUX is set), then change the status line to red
      %if #{TMUX}
      set -g status-bg red
      %endif

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
      bind r source-file /etc/tmux.conf

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
      set -g @dracula-plugins "cpu-usage ram-usage time"

      # Enable powerline glyphs
      set -g @dracula-show-powerline true

      # A faster refresh is nice, but may have performance impact (5)
      set -g @dracula-refresh-rate 5

      # `hostname` (full hostname), `session`, `shortname` (short name),
      # `smiley`, `window`, or any character.
      set -g @dracula-show-left-icon shortname

      # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
