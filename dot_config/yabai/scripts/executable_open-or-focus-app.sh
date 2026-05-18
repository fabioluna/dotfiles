#!/usr/bin/env sh

APP_NAME="${1:-}"
PREFERRED_SPACE="${2:-}"
APP_PATH="${3:-$APP_NAME}"
FOCUS_SPACE_SCRIPT="$HOME/.config/yabai/scripts/focus-space-with-window.sh"

if [ -z "$APP_NAME" ]; then
  exit 0
fi

open_app() {
  open -a "$APP_PATH" >/dev/null 2>&1
}

if ! command -v jq >/dev/null 2>&1; then
  if [ -n "$PREFERRED_SPACE" ]; then
    "$FOCUS_SPACE_SCRIPT" "$PREFERRED_SPACE" >/dev/null 2>&1 || true
  fi

  open_app
  exit 0
fi

app_name_lc="$(printf '%s' "$APP_NAME" | tr '[:upper:]' '[:lower:]')"

find_window_id() {
  yabai -m query --windows | jq -r --arg app "$app_name_lc" '
    map(select((.app | ascii_downcase) == $app and ((."is-minimized" // false) == false)))
    | (map(select(."has-focus" == true))[0] // .[0] // empty)
    | .id // empty
  '
}

window_id="$(find_window_id)"

if [ -n "$window_id" ]; then
  app_space="$(yabai -m query --windows --window "$window_id" | jq -r '.space // empty')"
  current_space="$(yabai -m query --spaces --space | jq -r '.index // empty')"

  if [ -n "$app_space" ] && [ "$app_space" != "$current_space" ]; then
    "$FOCUS_SPACE_SCRIPT" "$app_space" >/dev/null 2>&1 || true
  fi

  for _ in 1 2 3 4 5 6; do
    if yabai -m window --focus "$window_id" >/dev/null 2>&1; then
      exit 0
    fi

    sleep 0.05
  done

  open_app
  exit 0
fi

if [ -n "$PREFERRED_SPACE" ]; then
  "$FOCUS_SPACE_SCRIPT" "$PREFERRED_SPACE" >/dev/null 2>&1 || true
fi

open_app || exit 1

for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
  window_id="$(find_window_id)"

  if [ -n "$window_id" ]; then
    app_space="$(yabai -m query --windows --window "$window_id" | jq -r '.space // empty')"

    if [ -n "$app_space" ]; then
      "$FOCUS_SPACE_SCRIPT" "$app_space" >/dev/null 2>&1 || true
    fi

    yabai -m window --focus "$window_id" >/dev/null 2>&1 || true
    exit 0
  fi

  sleep 0.10
done

exit 0
