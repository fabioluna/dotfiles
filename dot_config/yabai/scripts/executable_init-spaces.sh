#!/usr/bin/env sh

RETINA_DISPLAY_INDEX="${1:-1}"
RETINA_SPACE_LABEL="${2:-retina}"

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

space_count="$(yabai -m query --spaces | jq 'length')"
while [ "$space_count" -lt 11 ]; do
  yabai -m space --create >/dev/null 2>&1 || break
  space_count=$((space_count + 1))
done

for i in 1 2 3 4 5 6 7 8 9 10; do
  yabai -m space "$i" --label "$i" >/dev/null 2>&1 || true
done

retina_index="$(yabai -m query --spaces | jq -r --arg label "$RETINA_SPACE_LABEL" '.[] | select(.label == $label) | .index' | head -n 1)"
if [ -z "$retina_index" ]; then
  retina_index=11
fi

yabai -m space "$retina_index" --label "$RETINA_SPACE_LABEL" >/dev/null 2>&1 || true
yabai -m space "$retina_index" --display "$RETINA_DISPLAY_INDEX" >/dev/null 2>&1 || true
