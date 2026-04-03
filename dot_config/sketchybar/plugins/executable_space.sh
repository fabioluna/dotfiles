#!/usr/bin/env bash

ITEM="$NAME"
WS="${1:-${ITEM#*.}}"

if ! command -v jq >/dev/null 2>&1; then
  sketchybar --set "$ITEM" icon="$WS" icon.font="Hack Nerd Font:Bold:14.0"
  sketchybar --set "$ITEM" background.color=0x00000000 icon.color=0xffffffff label.color=0xffffffff
  exit 0
fi

SPACES_JSON="$(yabai -m query --spaces 2>/dev/null)"

WS_INDEX="$(jq -r --arg ws "$WS" 'first(.[] | select(.label == $ws or ((.index|tostring) == $ws)) | .index) // empty' <<< "$SPACES_JSON")"

if [ -n "$WS_INDEX" ]; then
  APP_NAME="$(yabai -m query --windows --space "$WS_INDEX" 2>/dev/null | jq -r 'map(.app) | map(select(. != null and . != "")) | first // empty')"
else
  APP_NAME=""
fi

if [ -n "$APP_NAME" ]; then
  source "$HOME/.config/sketchybar/icon_map.sh"
  __icon_map "$APP_NAME"
  ICON_LIGATURE="${icon_result:-:default:}"
  sketchybar --set "$ITEM" icon="$ICON_LIGATURE" icon.font="sketchybar-app-font:Regular:14.0"
else
  sketchybar --set "$ITEM" icon="$WS" icon.font="Hack Nerd Font:Bold:14.0"
fi

FOCUSED="$(yabai -m query --spaces --space | jq -r 'if (.label != null and .label != "") then .label else (.index|tostring) end')"

if [ "$WS" = "$FOCUSED" ]; then
  sketchybar --set "$ITEM" background.color=0x00000000 icon.color=0xffff69b4 label.color=0xffff69b4
else
  sketchybar --set "$ITEM" background.color=0x00000000 icon.color=0xffffffff label.color=0xffffffff
fi
