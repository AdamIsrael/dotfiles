# Script to auto-start application(s)
#dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
sleep 0.3
waybar &
sleep 0.3
hypridle &
sleep 0.3
hyprpaper &
# firefox &
sleep 0.3
1password --silent &
