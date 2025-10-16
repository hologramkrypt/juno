#!/bin/bash
# Optimized Wallpaper selector (SUPER K)

wallDIR="$HOME/.wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

iDIR="$HOME/.config/swaync/images"
iDIRi="$HOME/.config/swaync/icons"

SRC="$HOME/.config/hypr/configs/appearance/wallpaper_effects/.wallpaper_current"
DST="$HOME/.config/hypr/configs/appearance/rofi-bg.jpg"

FPS=60  # reduced from 244
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
        cache_dir="$HOME/.cache/wallpaper_thumbs"
        mkdir -p "$cache_dir"

        if [[ "$name" =~ \.(mp4|mkv|mov|webm)$ ]]; then
            cache="$cache_dir/${name}.png"
            [[ ! -f "$cache" ]] && ffmpeg -v error -y -i "$pic_path" -ss 00:00:01 -vframes 1 -vf "scale=320:-1" "$cache"
        elif [[ "$name" =~ \.gif$ ]]; then
            cache="$cache_dir/${name}.png"
            [[ ! -f "$cache" ]] && magick "$pic_path[0]" -resize 320x180 "$cache"
        else
            cache="$pic_path"
        fi

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

save_current_wallpaper() {
    local wallpaper_path="$1"
    local wallpaper_current_dir="$HOME/.config/hypr/configs/appearance/wallpaper_effects"
    local wallpaper_current_file="$wallpaper_current_dir/.wallpaper_current"
    local rofi_bg="$HOME/.config/hypr/configs/appearance/rofi-bg.jpg"

    mkdir -p "$wallpaper_current_dir"
    cp "$wallpaper_path" "$wallpaper_current_file"

    # Generate low-res blurred version for Rofi (faster)
    if command -v magick >/dev/null 2>&1; then
        magick "$wallpaper_current_file" -resize 1920x1080 -blur 0x15 "$rofi_bg"
    fi
}

apply_image_wallpaper() {
    local image_path="$1"
    kill_wallpaper

    [[ ! $(pgrep -x "swww-daemon") ]] && swww-daemon --format xrgb & sleep 1

    for monitor in "${monitors[@]}"; do
        swww img -o "$monitor" "$image_path" $SWWW_PARAMS
    done

    save_current_wallpaper "$image_path"

    "$SCRIPTSDIR/WallustSwww.sh"
    "$SCRIPTSDIR/Refresh.sh"

    set_sddm_wallpaper
}

apply_video_wallpaper() {
    local video_path="$1"
    [[ ! $(command -v mpvpaper) ]] && { notify-send -i "$iDIR/error.png" "E-R-R-O-R" "mpvpaper not found"; return 1; }
    kill_wallpaper
    mpvpaper '*' -o "load-scripts=no no-audio --loop" "$video_path" &
    save_current_wallpaper "$video_path"
}

main() {
    pidof rofi &>/dev/null && pkill rofi
    file=$(navigate_and_select)
    [[ -f "$file" ]] || exit 1
    modify_startup_config "$file"
    [[ "$file" =~ \.(mp4|mkv|mov|webm)$ ]] && apply_video_wallpaper "$file" || apply_image_wallpaper "$file"
}

main

