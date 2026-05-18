#!/usr/bin/env sh

TARGET="${1:-}"

if [ -z "$TARGET" ]; then
  exit 0
fi

focus_space() {
  yabai -m space --focus "$1" >/dev/null 2>&1
}

if [ "$TARGET" = "current" ]; then
  :
elif [ "$TARGET" = "recent" ]; then
  focus_space recent || exit 0
else
  focus_space "$TARGET" || exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

if [ "$TARGET" != "current" ] && [ "$TARGET" != "recent" ]; then
  resolved_target="$(yabai -m query --spaces | jq -r --arg target "$TARGET" '.[] | select(.label == $target or ((.index | tostring) == $target)) | .index' | head -n 1)"
  if [ -n "$resolved_target" ]; then
    TARGET="$resolved_target"
    focus_space "$TARGET" || exit 0
  fi
fi

current_space="$(yabai -m query --spaces --space | jq -r '.index // empty')"

if [ -z "$current_space" ]; then
  exit 0
fi

for _ in 1 2 3 4 5 6; do
  window_id="$(yabai -m query --windows --space "$current_space" | jq -r '
    map(select((."is-minimized" // false) == false))
    | (map(select(."has-focus" == true))[0] // .[0] // empty)
    | .id // empty
  ')"

  if [ -n "$window_id" ] && yabai -m window --focus "$window_id" >/dev/null 2>&1; then
    exit 0
  fi

  sleep 0.05
done

exit 0
