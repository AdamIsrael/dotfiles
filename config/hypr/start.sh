# Script to auto-start application(s)
systemctl --user start xdg-desktop-portal
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
hyprpaper &
# waybar occasionally times out during startup, so capture the logs for debugging.
# add `-l debug` for verbosity
waybar > ~/.waybar.log &
hypridle &

# Start up the applets
1password --silent &
blueman-applet &
nm-applet &
dropbox start -i &

# Create a special workspace for a quake-style terminal
hyprctl dispatch exec "[workspace special:quake silent] ghostty" &

hyprctl dispatch exec "[workspace 1 silent] firefox" &
hyprctl dispatch exec "[workspace 2 silent] zed" &
hyprctl dispatch exec "[workspace 3] flatpak run com.discordapp.Discord" &
# hyprctl dispatch exec "[workspace 4 silent] slack" &
# hyprctl dispatch exec "[workspace 4 silent] hexchat" &
