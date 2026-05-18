#!/usr/bin/env sh

RETINA_DISPLAY_INDEX="${1:-}"
RESOLVE_RETINA_DISPLAY_SCRIPT="$HOME/.config/yabai/scripts/resolve-retina-display.sh"

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

RETINA_DISPLAY_INDEX="$("$RESOLVE_RETINA_DISPLAY_SCRIPT" "$RETINA_DISPLAY_INDEX")"

spaces_json="$(yabai -m query --spaces)"

printf '%s' "$spaces_json" | jq -r '.[] | "\(.index) \(.display)"' | while IFS=' ' read -r space_index display_index; do
  top_padding=32
  if [ "$display_index" = "$RETINA_DISPLAY_INDEX" ]; then
    top_padding=0
  fi

  yabai -m config --space "$space_index" top_padding "$top_padding"
  yabai -m config --space "$space_index" bottom_padding 0
  yabai -m config --space "$space_index" left_padding 1
  yabai -m config --space "$space_index" right_padding 1
  yabai -m config --space "$space_index" window_gap 0
done
