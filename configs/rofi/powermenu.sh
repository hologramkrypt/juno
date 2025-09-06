#!/usr/bin/env bash

# Rofi Power Menu - Dark Theme

options=" Lock\n Logout\n Reboot\n Shutdown\n Suspend"

selected=$(echo -e "$options" | rofi \
    -dmenu \
    -i \
    -p "Power:" \
    -lines 8 \
    -width 30 \
    -theme-str 'window {background-color: #141414;} 
                listview {background-color: #141414;foreground: #feffd3;} 
                element selected {background-color: #303030;foreground: #ffffff;} 
                * {font: "Hack Font 18";}' )

case "$selected" in
    " Lock")
        hyprlock
        ;;
    " Logout")
        hyprctl dispatch exit
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Shutdown")
        systemctl poweroff
        ;;
    " Suspend")
        systemctl suspend
        ;;
esac

