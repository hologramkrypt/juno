#!/bin/bash
# Script for changing blurs on the fly

notif="$HOME/.config/swaync/images"

STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "${STATE}" == "1" ]; then
	hyprctl keyword decoration:blur:size 3
	hyprctl keyword decoration:blur:passes 2
		notify-send -e -u low -i "Light Blur"

elif [ "${STATE}" == "2" ]; then
	hyprctl keyword decoration:blur:size 5
	hyprctl keyword decoration:blur:passes 3
			notify-send -e -u low -i "Medium Blur"

elif [ "${STATE}" == "3" ]; then
	hyprctl keyword decoration:blur:size 8
	hyprctl keyword decoration:blur:passes 4
			notify-send -e -u low -i "Heavy Blur"

else
	hyprctl keyword decoration:blur:size 1
	hyprctl keyword decoration:blur:passes 1
		notify-send -e -u low -i "Minimal Blur"
fi
