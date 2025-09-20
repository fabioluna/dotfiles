#!/usr/bin/env bash

get_spotify_info() {
  local status=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
  if [[ "$status" == "playing" ]]; then
    local artist=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)
    local track=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)
    local artwork_url=$(osascript -e 'tell application "Spotify" to artwork url of current track as string' 2>/dev/null)
    
    # Download and set artwork
    local artwork_path="/tmp/spotify_artwork.png"
    if [[ -n "$artwork_url" && "$artwork_url" != "missing value" ]]; then
      curl -s "$artwork_url" -o "$artwork_path"
      # Convert and resize using sips
      if command -v sips >/dev/null 2>&1; then
        sips -s format png -Z 20 "$artwork_path" --out "$artwork_path" >/dev/null 2>&1
      fi
      
      # Use background image instead of icon
      sketchybar --set $NAME background.image="$artwork_path" \
                           background.drawing=on \
                           background.image.corner_radius=3 \
                           icon=" " \
                           icon.drawing=on
    else
      sketchybar --set $NAME background.drawing=off \
                           icon="♪" \
                           icon.drawing=on
    fi
    
    local info="$artist — $track"
    sketchybar --set $NAME label="$info"
    return 0
  fi
  return 1
}

get_music_info() {
  local status=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)
  if [[ "$status" == "playing" ]]; then
    local artist=$(osascript -e 'tell application "Music" to artist of current track as string' 2>/dev/null)
    local track=$(osascript -e 'tell application "Music" to name of current track as string' 2>/dev/null)
    
    # For Apple Music, just use the music icon
    sketchybar --set $NAME background.drawing=off \
                           icon="♪" \
                           icon.drawing=on
    
    local info="$artist — $track"
    sketchybar --set $NAME label="$info"
    return 0
  fi
  return 1
}

if ! get_spotify_info && ! get_music_info; then
  sketchybar --set $NAME label="" background.drawing=off icon.drawing=off
fi