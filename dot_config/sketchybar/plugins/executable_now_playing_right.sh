#!/usr/bin/env bash

clean_value() {
  local value="$1"
  if [ "$value" = "null" ] || [ "$value" = "(null)" ]; then
    echo ""
  else
    echo "$value"
  fi
}

extract_source_name() {
  local source="$1"
  local bundle="$2"

if [ -n "$source" ]; then
    echo "$source"
    return
  fi

  if [ -n "$bundle" ]; then
    case "$bundle" in
      com.spotify.client) echo "Spotify" ;;
      com.apple.Music) echo "Music" ;;
      com.apple.podcasts) echo "Podcasts" ;;
      com.google.Chrome*) echo "Chrome" ;;
      org.mozilla.firefox*) echo "Firefox" ;;
      com.apple.Safari*) echo "Safari" ;;
      *) echo "${bundle##*.}" ;;
    esac
  fi
}

set_album_art() {
  local art_data="$1"
  local art_url="$2"
  local art_path="/tmp/sketchybar-now-playing-right.png"
  local wrote_art=0

  if [ -n "$art_data" ]; then
    python3 - "$art_data" "$art_path" <<'PY' >/dev/null 2>&1
import base64
import sys

raw = sys.argv[1].strip()
path = sys.argv[2]

if raw.startswith('data:'):
    raw = raw.split(',', 1)[1]

with open(path, 'wb') as f:
    f.write(base64.b64decode(raw))
PY
    if [ -s "$art_path" ]; then
      wrote_art=1
    fi
  fi

  if [ "$wrote_art" -eq 0 ] && [ -n "$art_url" ]; then
    curl -fsS --connect-timeout 3 --max-time 10 "$art_url" -o "$art_path" >/dev/null 2>&1 || true
    if [ -s "$art_path" ] && command -v sips >/dev/null 2>&1; then
      sips -s format png "$art_path" --out "$art_path" >/dev/null 2>&1 || true
    fi
    if [ -s "$art_path" ]; then
      wrote_art=1
    fi
  fi

  if [ "$wrote_art" -eq 1 ]; then
    sketchybar --set "$NAME" \
      icon=" " \
      icon.background.drawing=on \
      icon.background.image="$art_path" \
      icon.background.image.scale=1.0 \
      icon.background.height=18 \
      icon.background.corner_radius=4
  else
    sketchybar --set "$NAME" \
      icon="󰎈" \
      icon.background.drawing=off
  fi
}

get_now_playing() {
  local meta_output
  meta_output="$(nowplaying-cli get sourceApp bundleIdentifier title artist album artworkData artworkURL 2>/dev/null)"

  SOURCE_APP=""
  BUNDLE_ID=""
  TITLE=""
  ARTIST=""
  ALBUM=""
  ARTWORK_DATA=""
  ARTWORK_URL=""

  {
    IFS= read -r SOURCE_APP
    IFS= read -r BUNDLE_ID
    IFS= read -r TITLE
    IFS= read -r ARTIST
    IFS= read -r ALBUM
    IFS= read -r ARTWORK_DATA
    IFS= read -r ARTWORK_URL
  } <<EOF
$meta_output
EOF

  SOURCE_APP="$(clean_value "$SOURCE_APP")"
  BUNDLE_ID="$(clean_value "$BUNDLE_ID")"
  TITLE="$(clean_value "$TITLE")"
  ARTIST="$(clean_value "$ARTIST")"
  ALBUM="$(clean_value "$ALBUM")"
  ARTWORK_DATA="$(clean_value "$ARTWORK_DATA")"
  ARTWORK_URL="$(clean_value "$ARTWORK_URL")"

  if [ -z "$TITLE" ]; then
    return 1
  fi

  return 0
}

if ! get_now_playing; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

SOURCE_NAME="$(extract_source_name "$SOURCE_APP" "$BUNDLE_ID")"

DETAILS="$TITLE"
if [ -n "$ARTIST" ]; then
  DETAILS="$ARTIST - $DETAILS"
fi
if [ -n "$ALBUM" ]; then
  DETAILS="$ALBUM - $DETAILS"
fi
if [ -n "$SOURCE_NAME" ]; then
  DETAILS="$SOURCE_NAME: $DETAILS"
fi

set_album_art "$ARTWORK_DATA" "$ARTWORK_URL"

sketchybar --set "$NAME" \
  drawing=on \
  label="$DETAILS"
