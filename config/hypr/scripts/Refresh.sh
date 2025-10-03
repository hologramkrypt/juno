#!/bin/bash
# Scripts for refreshing ags, waybar, rofi, swaync, wallust

SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/scripts

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Kill already running processes
_ps=(waybar rofi swaync swaybg ags qs)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill -f "${_prs}"
        # Wait for the specific process to fully terminate
        while pidof "${_prs}" >/dev/null; do
            sleep 0.1
        done
    fi
done

# Wait for processes to fully terminate
sleep 1

# quit ags & relaunch ags
ags -q
sleep 0.5
ags &

# relaunch quickshell
qs &

# relaunch swaync
sleep 0.6
swaync > /dev/null 2>&1 &

# reload swaync
sleep 0.3
swaync-client --reload-config

# run wallust
sleep 2
wallust run ~/.config/hypr/configs/appearance/wallpaper_effects/.wallpaper_current
sleep 1.5
notify-send Colors applied

# Restart waybar - ensure it's not already running
if ! pidof waybar >/dev/null; then
    waybar &
fi


