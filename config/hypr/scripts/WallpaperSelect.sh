#!/bin/bash
# Wallpaper selector (SUPER K)

wallDIR="$HOME/.wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

iDIR="$HOME/.config/swaync/images"
iDIRi="$HOME/.config/swaync/icons"

FPS=60
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Monitors
monitors=($(hyprctl monitors -j | jq -r '.[].name'))
scale_factor=$(hyprctl monitors -j | jq -r '.[0].scale')
monitor_height=$(hyprctl monitors -j | jq -r '.[0].height')
icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

rofi_theme="$HOME/.config/rofi/config-wallpaper.rasi"
RANDOM_PIC_NAME=". random"

kill_wallpaper() {
				pkill sww-daemon 2>/dev/null
				pkill mpvpaper 2>/dev/null
				pkill swaybg 2>/dev/null
				pkill hyprpaper 2>/dev/null
}

collect_wallpapers() {
				local dir="$1"
				mapfile -d '' PICS < <(find -L "$dir" -maxdepth 1 -type f \( \
								-iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o \
								-iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" -o \
								-iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.webm" \) -print0)
}

combined_menu() {
				local dir="$1"

				# Back button
				[[ "$dir" != "$wallDIR" ]] && printf "%s\x00icon\x1f%s\n" ".. (back)" "$HOME/.config/rofi/icons/folder.png"

				# Folders
				while IFS= read -r -d '' d; do
								folder_name="$(basename "$d")"
								printf "%s\x00icon\x1f%s\x00display\x1f%s\n" "$folder_name/" "$HOME/.config/rofi/icons/folder.png" "$folder_name"
				done < <(find "$dir" -maxdepth 1 -type d -not -path "$dir" -print0 | sort -z)

				# Wallpapers
				collect_wallpapers "$dir"
				[[ ${#PICS[@]} -gt 0 ]] || return

				# Random entry
				printf "%s\x00icon\x1f%s\x00display\x1f\n" "$RANDOM_PIC_NAME" "${PICS[$((RANDOM % ${#PICS[@]}))]}"

				for pic_path in "${PICS[@]}"; do
								name=$(basename "$pic_path")
								# Generate thumbnail
								if [[ "$name" =~ \.(mp4|mkv|mov|webm)$ ]]; then
												cache="$HOME/.cache/video_preview/$name.png"
												[[ ! -f "$cache" ]] && mkdir -p "$HOME/.cache/video_preview" && ffmpeg -v error -y -i "$pic_path" -ss 00:00:01 -vframes 1 "$cache"
								elif [[ "$name" =~ \.gif$ ]]; then
												cache="$HOME/.cache/gif_preview/$name.png"
												[[ ! -f "$cache" ]] && mkdir -p "$HOME/.cache/gif_preview" && magick "$pic_path[0]" -resize 1920x1080 "$cache"
								else
												cache="$pic_path"
								fi
								# Send empty label to hide path
								printf "%s\x00icon\x1f%s\x00display\x1f\n" "$pic_path" "$cache"
				done
}

navigate_and_select() {
				local dir="$wallDIR"
				while true; do
								choice=$(combined_menu "$dir" | rofi -i -show -dmenu -config "$rofi_theme" -theme-str "$rofi_override" | xargs)
								[[ -z "$choice" ]] && exit 0

								if [[ "$choice" == ".. (back)" ]]; then
												dir=$(dirname "$dir")
								elif [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
												collect_wallpapers "$dir"
												echo "${PICS[$((RANDOM % ${#PICS[@]}))]}"
												return
								elif [[ "$choice" =~ /$ ]]; then
												dir="$dir/${choice%/}"
								elif [[ -f "$choice" ]]; then
												echo "$choice"
												return
								fi
				done
}

# Save current wallpaper to .wallpaper_current
save_current_wallpaper() {
				local wallpaper_path="$1"
				local wallpaper_current_dir="$HOME/.config/hypr/configs/appearance/wallpaper_effects"
				local wallpaper_current_file="$wallpaper_current_dir/.wallpaper_current"

				# Create directory if it doesn't exist
				mkdir -p "$wallpaper_current_dir"

				# Copy the chosen wallpaper to overwrite .wallpaper_current
				cp "$wallpaper_path" "$wallpaper_current_file"
}

# Offer SDDM Simple Wallpaper Option (only for non-video wallpapers)
set_sddm_wallpaper() {
		sleep 1
		sddm_simple="/usr/share/sddm/themes/simple_sddm_2"

		if [ -d "$sddm_simple" ]; then

				# Check if yad is running to avoid multiple notifications
				if pidof yad >/dev/null; then
						killall yad
				fi

				if yad --info --text="Set current wallpaper as SDDM background?\n\nNOTE: This only applies to SIMPLE SDDM v2 Theme" \
						--text-align=left \
						--title="SDDM Background" \
						--timeout=5 \
						--timeout-indicator=right \
						--button="yes:0" \
						--button="no:1"; then

						# Check if terminal exists
						if ! command -v "$terminal" &>/dev/null; then
								notify-send -i "$iDIR/error.png" "Missing $terminal" "Install $terminal to enable setting of wallpaper background"
								exit 1
						fi

			exec $SCRIPTSDIR/sddm_wallpaper.sh --normal

				fi
		fi
}

# Startup config updater
modify_startup_config() {
		local selected_file="$1"
		local startup_config="$HOME/.config/hypr/configs/autoruns.conf"

		if [[ "$selected_file" =~ \.(mp4|mkv|mov|webm)$ ]]; then
				sed -i '/^\s*exec-once\s*=\s*swww-daemon\s*--format\s*xrgb\s*$/s/^/\#/' "$startup_config"
				sed -i '/^\s*#\s*exec-once\s*=\s*mpvpaper\s*.*$/s/^#\s*//;' "$startup_config"
				selected_file="${selected_file/#$HOME/\$HOME}"
				sed -i "s|^\$livewallpaper=.*|\$livewallpaper=\"$selected_file\"|" "$startup_config"
				echo "Configured for live wallpaper (video)."
		else
				sed -i '/^\s*#\s*exec-once\s*=\s*swww-daemon\s*--format\s*xrgb\s*$/s/^\s*#\s*//;' "$startup_config"
				sed -i '/^\s*exec-once\s*=\s*mpvpaper\s*.*$/s/^/\#/' "$startup_config"
				echo "Configured for static wallpaper (image)."
		fi
}

apply_image_wallpaper() {
		local image_path="$1"

		kill_wallpaper

		if ! pgrep -x "swww-daemon" >/dev/null; then
				echo "Starting swww-daemon..."
				swww-daemon --format xrgb &
				sleep 1
		fi

		# Apply to all monitors
		for monitor in "${monitors[@]}"; do
				swww img -o "$monitor" "$image_path" $SWWW_PARAMS
		done

		# Save current wallpaper
		save_current_wallpaper "$image_path"

		# Run additional scripts
		"$SCRIPTSDIR/WallustSwww.sh"
		sleep 2
		"$SCRIPTSDIR/Refresh.sh"
		sleep 1

		set_sddm_wallpaper
}

apply_video_wallpaper() {
		local video_path="$1"

		# Check if mpvpaper is installed
		if ! command -v mpvpaper &>/dev/null; then
				notify-send -i "$iDIR/error.png" "E-R-R-O-R" "mpvpaper not found"
				return 1
		fi
		kill_wallpaper

		# Apply video wallpaper using mpvpaper
		mpvpaper '*' -o "load-scripts=no no-audio --loop" "$video_path" &

		# Save current wallpaper
		save_current_wallpaper "$video_path"
}

main() {
				pidof rofi &>/dev/null && pkill rofi
				file=$(navigate_and_select)
				[[ -f "$file" ]] || exit 1
				modify_startup_config "$file"
				if [[ "$file" =~ \.(mp4|mkv|mov|webm)$ ]]; then
								apply_video_wallpaper "$file"
				else
								apply_image_wallpaper "$file"
				fi
}
main

