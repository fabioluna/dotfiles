#!/usr/bin/env bash

ITEM="$NAME"
WS="${1:-${ITEM#*.}}"

FOCUSED="$(yabai -m query --spaces --space | jq -r 'if (.label != null and .label != "") then .label else (.index|tostring) end')"

if [ "$WS" = "$FOCUSED" ]; then
  sketchybar --set "$ITEM" background.color=0xffff69b4 icon.color=0xff11111b label.color=0xff11111b
else
  sketchybar --set "$ITEM" background.color=0x00000000 icon.color=0xffffffff label.color=0xffffffff
fi
