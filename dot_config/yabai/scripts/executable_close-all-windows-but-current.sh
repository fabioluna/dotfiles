#!/usr/bin/env sh

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

current_id="$(yabai -m query --windows --window | jq -r '.id')"
space_index="$(yabai -m query --windows --window | jq -r '.space')"

yabai -m query --windows --space "$space_index" | jq -r --argjson id "$current_id" '.[] | select(.id != $id) | .id' | while read -r id; do
  yabai -m window "$id" --close
done
