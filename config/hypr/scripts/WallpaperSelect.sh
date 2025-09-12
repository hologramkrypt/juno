#!/bin/bash
# Wallpaper selector (SUPER K)

# WALLPAPERS PATH
terminal=kitty
wallDIR="$HOME/.wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

# Directory for swaync
iDIR="$HOME/.config/swaync/images"
iDIRi="$HOME/.config/swaync/icons"

# swww transition config
FPS=60
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Dependency check
if ! command -v bc &>/dev/null; then
  notify-send -i "$iDIR/error.png" "bc missing" "Install package bc first"
  exit 1
fi

# Monitors
monitors=($(hyprctl monitors -j | jq -r '.[].name'))
scale_factor=$(hyprctl monitors -j | jq -r '.[0].scale')
monitor_height=$(hyprctl monitors -j | jq -r '.[0].height')

icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

rofi_theme="$HOME/.config/rofi/config-wallpaper.rasi"

# Kill wallpaper daemons
kill_wallpaper_for_video() {
  swww kill 2>/dev/null
  pkill mpvpaper 2>/dev/null
  pkill swaybg 2>/dev/null
  pkill hyprpaper 2>/dev/null
}
kill_wallpaper_for_image() {
  pkill mpvpaper 2>/dev/null
  pkill swaybg 2>/dev/null
  pkill hyprpaper 2>/dev/null
}

# Collect wallpapers from current directory
collect_wallpapers() {
  local current_dir="$1"
  mapfile -d '' PICS < <(find -L "${current_dir}" -maxdepth 1 -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o \
    -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" -o \
    -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.webm" \) -print0)
}

RANDOM_PIC_NAME=". random"

# Rofi command
rofi_command="rofi -i -show -dmenu -config $rofi_theme -theme-str $rofi_override"

# Combined menu builder - shows both folders and files in same view
combined_menu() {
  local current_dir="$1"

  # Add back option if not in root wallpaper directory
  if [[ "$current_dir" != "$wallDIR" ]]; then
    printf "%s\x00icon\x1f%s\n" ".. (back)" "$HOME/.config/rofi/icons/folder.png"
  fi

  # List directories
  while IFS= read -r -d '' dir; do
    dir_name=$(basename "$dir")
    printf "%s\x00icon\x1f%s\n" "$dir_name/" "$HOME/.config/rofi/icons/folder.png"
  done < <(find "$current_dir" -maxdepth 1 -type d -not -path "$current_dir" -print0 | sort -z)

  # List wallpapers from current directory
  collect_wallpapers "$current_dir"
  if [[ ${#PICS[@]} -gt 0 ]]; then
    local RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"

    IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))

    printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"

    for pic_path in "${sorted_options[@]}"; do
      pic_name=$(basename "$pic_path")
      if [[ "$pic_name" =~ \.gif$ ]]; then
        cache_gif_image="$HOME/.cache/gif_preview/${pic_name}.png"
        if [[ ! -f "$cache_gif_image" ]]; then
          mkdir -p "$HOME/.cache/gif_preview"
          magick "$pic_path[0]" -resize 1920x1080 "$cache_gif_image"
        fi
        printf "%s\x00icon\x1f%s\n" "$pic_path" "$cache_gif_image"
      elif [[ "$pic_name" =~ \.(mp4|mkv|mov|webm|MP4|MKV|MOV|WEBM)$ ]]; then
        cache_preview_image="$HOME/.cache/video_preview/${pic_name}.png"
        if [[ ! -f "$cache_preview_image" ]]; then
          mkdir -p "$HOME/.cache/video_preview"
          ffmpeg -v error -y -i "$pic_path" -ss 00:00:01.000 -vframes 1 "$cache_preview_image"
        fi
        printf "%s\x00icon\x1f%s\n" "$pic_path" "$cache_preview_image"
      else
        printf "%s\x00icon\x1f%s\n" "$pic_path" "$pic_path"
      fi
    done
  fi
}

# Startup config updater
modify_startup_config() {
  local selected_file="$1"
  local startup_config="$HOME/.config/hypr/UserConfigs/autoruns.conf"

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

# Applyers
apply_image_wallpaper() {
  local image_path="$1"
  kill_wallpaper_for_image
  if ! pgrep -x "swww-daemon" >/dev/null; then
    swww-daemon --format xrgb &
    sleep 1
  fi
  for mon in "${monitors[@]}"; do
    swww img -o "$mon" "$image_path" $SWWW_PARAMS
  done
  "$SCRIPTSDIR/WallustSwww.sh"
  sleep 2
  "$SCRIPTSDIR/Refresh.sh"
  sleep 1
}
apply_video_wallpaper() {
  local video_path="$1"
  if ! command -v mpvpaper &>/dev/null; then
    notify-send -i "$iDIR/error.png" "E-R-R-O-R" "mpvpaper not found"
    return 1
  fi
  kill_wallpaper_for_video
  mpvpaper '*' -o "load-scripts=no no-audio --loop" "$video_path" &
}

# Navigate through folders and select wallpapers
navigate_and_select() {
  local current_dir="$wallDIR"

  while true; do
    choice=$(combined_menu "$current_dir" | $rofi_command -p "Select:")

    choice=$(echo "$choice" | xargs)

    if [[ -z "$choice" ]]; then
      echo "No choice selected. Exiting."
      exit 0
    fi

    if [[ "$choice" == ".. (back)" ]]; then
      current_dir=$(dirname "$current_dir")
    elif [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
      collect_wallpapers "$current_dir"
      local RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
      echo "$RANDOM_PIC"
      return 0
    elif [[ "$choice" =~ /$ ]]; then
      # It's a directory
      folder_name="${choice%/}"
      current_dir="$current_dir/$folder_name"
    elif [[ -f "$choice" ]]; then
      # It's a file (full path)
      echo "$choice"
      return 0
    else
      echo "Invalid selection: $choice"
      continue
    fi
  done
}

# Main logic
main() {
  selected_file=$(navigate_and_select)

  if [[ ! -f "$selected_file" ]]; then
    echo "File not found: $selected_file"
    exit 1
  fi

  # Run wallust first to ensure color sync with current wallpaper
  wallust run "$selected_file"

  modify_startup_config "$selected_file"

  if [[ "$selected_file" =~ \.(mp4|mkv|mov|webm|MP4|MKV|MOV|WEBM)$ ]]; then
    apply_video_wallpaper "$selected_file"
  else
    apply_image_wallpaper "$selected_file"
  fi
}

if pidof rofi >/dev/null; then pkill rofi; fi

main
