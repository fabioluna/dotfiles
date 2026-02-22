#!/usr/bin/env sh

KITTY_APP_PATH="/Applications/Kitty.app"

if ! command -v jq >/dev/null 2>&1; then
  open -a "$KITTY_APP_PATH"
  exit 0
fi

kitty_window_id="$(yabai -m query --windows | jq -r '
  map(select((.app | ascii_downcase) == "kitty"))
  | (map(select(."has-focus" == true))[0] // .[0] // empty)
  | .id // empty
')"

if [ -z "$kitty_window_id" ]; then
  open -a "$KITTY_APP_PATH"
  exit 0
fi

kitty_space="$(yabai -m query --windows --window "$kitty_window_id" | jq -r '.space // empty')"
current_space="$(yabai -m query --spaces --space | jq -r '.index // empty')"

if [ -n "$kitty_space" ] && [ -n "$current_space" ] && [ "$kitty_space" != "$current_space" ]; then
  yabai -m space --focus "$kitty_space" >/dev/null 2>&1 || true
fi

yabai -m window --focus "$kitty_window_id" >/dev/null 2>&1 || open -a "$KITTY_APP_PATH"
