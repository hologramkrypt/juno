#!/usr/bin/env bash

# Rofi Power Menu - uses normal Rofi theme
ROFI_THEME="~/.config/rofi/themes/KooL_style-4.rasi"

options=" Lock\n Logout\n Reboot\n Shutdown\n Suspend"

selected=$(echo -e "$options" | rofi \
    -dmenu \
    -i \
    -p "Power:" \
    -lines 8 \
    -width 30 \
    -theme "$ROFI_THEME"
)

case "$selected" in
    " Lock") exec hyprlock ;;
    " Logout") hyprctl dispatch exit ;;
    " Reboot") systemctl reboot ;;
    " Shutdown") systemctl poweroff ;;
    " Suspend") systemctl suspend ;;
esac
