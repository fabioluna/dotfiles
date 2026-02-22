#!/usr/bin/env sh

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

retina_index="$(yabai -m query --spaces | jq -r '.[] | select(.label == "retina") | .index' | head -n 1)"
if [ -z "$retina_index" ]; then
  retina_index=11
fi

yabai -m space --focus "$retina_index"
