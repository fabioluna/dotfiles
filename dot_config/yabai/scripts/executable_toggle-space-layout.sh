#!/usr/bin/env sh

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

layout="$(yabai -m query --spaces --space | jq -r '.type')"

if [ "$layout" = "float" ]; then
  yabai -m space --layout bsp
else
  yabai -m space --layout float
fi
