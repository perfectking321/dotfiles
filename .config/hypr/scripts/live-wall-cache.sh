#!/usr/bin/env bash
# Generate JPEG thumbnails (400x225) for all live wallpapers
# Skips videos that already have a thumbnail.

LIVE_DIR="$HOME/Downloads/Live Wallpapers"
THUMB_DIR="$HOME/.config/hypr/.cache/live-wallpaper-thumbs"

mkdir -p "$THUMB_DIR"

generate_thumb() {
    local video="$1"
    local name
    name="$(basename "${video%.*}")"
    local thumb="$THUMB_DIR/${name}.jpg"

    if [[ -f "$thumb" ]]; then
        echo "  skip: $name"
        return
    fi

    # Try at 3s first, fall back to 1s for short videos
    ffmpeg -loglevel error -ss 3 -i "$video" \
        -vframes 1 -vf "scale=400:225" -q:v 3 "$thumb" 2>/dev/null

    if [[ ! -f "$thumb" ]]; then
        ffmpeg -loglevel error -ss 1 -i "$video" \
            -vframes 1 -vf "scale=400:225" -q:v 3 "$thumb" 2>/dev/null
    fi

    if [[ -f "$thumb" ]]; then
        echo "  done: $name"
    else
        echo "  FAIL: $name"
    fi
}

export -f generate_thumb
export THUMB_DIR

echo "Scanning: $LIVE_DIR"
echo "Output:   $THUMB_DIR"
echo ""

find "$LIVE_DIR" -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) -print0 \
    | sort -z \
    | xargs -0 -P 4 -I{} bash -c 'generate_thumb "$@"' _ {}

total=$(find "$LIVE_DIR" -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) | wc -l)
existing=$(find "$THUMB_DIR" -name "*.jpg" | wc -l)

echo ""
echo "Done. $existing / $total thumbnails in $THUMB_DIR"
