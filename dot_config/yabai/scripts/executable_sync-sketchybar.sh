#!/usr/bin/env sh

RETINA_DISPLAY_INDEX="${1:-}"
SKETCHYBAR_CONFIG="$HOME/.config/sketchybar/sketchybarrc"
RESOLVE_RETINA_DISPLAY_SCRIPT="$HOME/.config/yabai/scripts/resolve-retina-display.sh"

if ! command -v sketchybar >/dev/null 2>&1; then
  exit 0
fi

if command -v yabai >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  RETINA_DISPLAY_INDEX="$("$RESOLVE_RETINA_DISPLAY_SCRIPT" "$RETINA_DISPLAY_INDEX")"
else
  [ -z "$RETINA_DISPLAY_INDEX" ] && RETINA_DISPLAY_INDEX=1
fi

if pgrep -x sketchybar >/dev/null 2>&1; then
  pkill -x sketchybar >/dev/null 2>&1 || true
  sleep 0.2
fi

RETINA_DISPLAY_INDEX="$RETINA_DISPLAY_INDEX" sketchybar --config "$SKETCHYBAR_CONFIG" >/dev/null 2>&1 &
