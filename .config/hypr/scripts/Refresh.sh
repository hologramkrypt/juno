#!/bin/bash
# Refresh Hyprland UI components

SCRIPTSDIR="$HOME/.config/hypr/scripts"
UserScripts="$HOME/.config/hypr/scripts"

# List of processes to kill
_procs=(waybar rofi swaync swaybg ags qs)

for p in "${_procs[@]}"; do
    pkill -x "$p" 2>/dev/null
    # Wait for processes to terminate
    while pidof -x "$p" >/dev/null; do
        sleep 0.5
    done
done

# Small delay to ensure cleanup
sleep 0.5

# Run wallust once
wallust run $HOME/.config/hypr/configs/appearance/wallpaper_effects/.wallpaper_current
notify-send --replace-id=1 "System refreshed"

# Relaunch services (background)
ags &
qs &
swaync > /dev/null 2>&1 &
swaync-client --reload-config
hyprctl reload &

# Start waybar only if not already running
sleep 0.5
if ! pidof -x waybar >/dev/null; then
    waybar &
fi
