#!/usr/bin/env sh

RETINA_DISPLAY_INDEX="${1:-1}"

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

space_json="$(yabai -m query --spaces --space)"
space_index="$(printf '%s' "$space_json" | jq -r '.index')"
display_index="$(printf '%s' "$space_json" | jq -r '.display')"

top_padding=32
if [ "$display_index" = "$RETINA_DISPLAY_INDEX" ]; then
  top_padding=0
fi

yabai -m config --space "$space_index" top_padding "$top_padding"
yabai -m config --space "$space_index" bottom_padding 0
yabai -m config --space "$space_index" left_padding 1
yabai -m config --space "$space_index" right_padding 1
yabai -m config --space "$space_index" window_gap 0
