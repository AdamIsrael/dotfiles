# Script to auto-start application(s)
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
hyprpaper &
# waybar occasionally times out during startup, so capture the logs for debugging.
# add `-l debug` for verbosity
waybar > ~/.waybar.log &
hypridle &

1password --silent &
hyprctl dispatch exec "[workspace special:quake silent] ghostty" &

# If needed, add a sleep here
hyprctl dispatch exec "[workspace 1 silent] firefox" &
hyprctl dispatch exec "[workspace 2 silent] zeditor" &
# hyprctl dispatch exec "[workspace 3] discord" &
# hyprctl dispatch exec "[workspace 4 silent] slack" &
# hyprctl dispatch exec "[workspace 4 silent] hexchat" &
