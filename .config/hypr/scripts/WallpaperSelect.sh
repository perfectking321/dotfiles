#!/bin/bash

scriDir="$HOME/.config/hypr/scripts"
cache_dir="$HOME/.config/hypr/.cache"
wallCache="$cache_dir/.wallpaper"
theme=$(cat "$HOME/.config/hypr/.cache/.theme")
wallDIR="$HOME/.config/hypr/Wallpapers/${theme}"
liveWallDIR="$HOME/Downloads/Live Wallpapers"
THUMB_DIR="$HOME/.config/hypr/.cache/live-wallpaper-thumbs"

[[ ! -f "$wallCache" ]] && touch "$wallCache"

# Transition config
FPS=60
TYPE="random"
DURATION=1
BEZIER=".43,1.19,1,.4"
AWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

if command -v awww &> /dev/null; then
    ENGINE=awww
elif command -v swww &> /dev/null; then
    ENGINE=swww
fi


# Retrieve image files
PICS=($(ls "${wallDIR}" | grep -E ".jpg$|.jpeg$|.png$|.gif$"))
RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME="${#PICS[@]}. random"

# Retrieve live wallpaper (video) files
LIVE_PICS=()
if [[ -d "$liveWallDIR" ]]; then
    while IFS= read -r -d '' f; do
        LIVE_PICS+=("$(basename "$f")")
    done < <(find "$liveWallDIR" -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) -print0 | sort -z)
fi

# Rofi command ( style )
rofi_command1="rofi -show -dmenu -config ~/.config/rofi/themes/rofi-wall.rasi"
rofi_command2="rofi -show -dmenu -config ~/.config/rofi/themes/rofi-wall-2.rasi"

menu() {
  for i in "${!PICS[@]}"; do
    # Displaying .gif to indicate animated images
    if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
      printf "$(echo "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${wallDIR}/${PICS[$i]}\n"
    else
      printf "${PICS[$i]}\n"
    fi
  done

  printf "$RANDOM_PIC_NAME\n"

  # Live wallpapers section with thumbnails
  for vid in "${LIVE_PICS[@]}"; do
    thumb="$THUMB_DIR/${vid%.*}.jpg"
    if [[ -f "$thumb" ]]; then
      printf "🎬 ${vid%.*}\x00icon\x1f${thumb}\n"
    else
      printf "🎬 ${vid%.*}\n"
    fi
  done
}

case $1 in
    thm1)
        choice=$(menu | ${rofi_command1})
        ;;
    thm2)
        choice=$(menu | ${rofi_command2})
        ;;
esac

# No choice case
if [[ -z $choice ]]; then
  exit 0
fi

# Random choice case
if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
    ${ENGINE} img "${wallDIR}/${RANDOM_PIC}" $AWWW_PARAMS
  exit 0
fi

# Live wallpaper selected (prefixed with 🎬)
if [[ "$choice" == "🎬 "* ]]; then
    vidname="${choice#🎬 }"
    # Find matching file
    for vid in "${LIVE_PICS[@]}"; do
        if [[ "${vid%.*}" == "$vidname" ]]; then
            # Kill any existing mpvpaper instance
            for pid in $(pgrep -x mpvpaper); do kill "$pid" 2>/dev/null; done
            # Stop the static wallpaper daemon
            ${ENGINE} kill 2>/dev/null || true
            sleep 0.3
            # Restart daemon (needed after kill)
            ${ENGINE}-daemon &>/dev/null &
            sleep 0.5
            # Launch mpvpaper on all outputs, looping, fullscreen cover
            mpvpaper -o "loop-file=inf --no-audio --panscan=1.0" '*' "$liveWallDIR/$vid" &
            notify-send "🎬 Live Wallpaper" "$vidname" -t 2000
            # Point current_wallpaper to thumbnail so hyprlock gets a real image
            # (symlinking the mp4 directly gives hyprlock a blank background)
            thumb_src="$THUMB_DIR/${vid%.*}.jpg"
            if [[ -f "$thumb_src" ]]; then
                cp "$thumb_src" "$cache_dir/hyprlock_livewall_bg.jpg"
                ln -sf "$cache_dir/hyprlock_livewall_bg.jpg" "$cache_dir/current_wallpaper.png"
            else
                ln -sf "$liveWallDIR/$vid" "$cache_dir/current_wallpaper.png"
            fi
            echo "$vidname" > "$wallCache"
            sleep 0.5
            "$scriDir/wallcache.sh"
            exit 0
        fi
    done
fi

# Find the index of the selected static image
pic_index=-1
for i in "${!PICS[@]}"; do
  filename=$(basename "${PICS[$i]}")
  if [[ "$filename" == "$choice"* ]]; then
    pic_index=$i
    break
  fi
done

if [[ $pic_index -ne -1 ]]; then
    # Stop any running mpvpaper before switching to static
    for pid in $(pgrep -x mpvpaper); do kill "$pid" 2>/dev/null; done
    sleep 0.2
    notify-send -i "${wallDIR}/${PICS[$pic_index]}" "Changing wallpaper" -t 1500
    ${ENGINE} img "${wallDIR}/${PICS[$pic_index]}" $AWWW_PARAMS

    ln -sf "${wallDIR}/${PICS[$pic_index]}" "$cache_dir/current_wallpaper.png"
    basename="$(basename "${wallDIR}/${PICS[$pic_index]}")"
    wallName="${basename%.*}"
    echo "$wallName" > "$wallCache"

else
    echo "Image not found."
    exit 1
fi

sleep 0.5
"$scriDir/wallcache.sh"
"$scriDir/themes.sh"
