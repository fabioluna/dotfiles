#!/usr/bin/env bash

WORKSPACES=("$@")

if [ ${#WORKSPACES[@]} -eq 0 ]; then
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  for ws in "${WORKSPACES[@]}"; do
    sketchybar --set "space.$ws" \
      icon="$ws" \
      icon.font="Hack Nerd Font:Bold:14.0" \
      background.color=0x00000000 \
      icon.color=0xffffffff \
      label.color=0xffffffff
  done
  exit 0
fi

SPACES_JSON="$(yabai -m query --spaces 2>/dev/null)"
[ -z "$SPACES_JSON" ] && exit 0

WINDOWS_JSON="$(yabai -m query --windows 2>/dev/null)"
[ -z "$WINDOWS_JSON" ] && WINDOWS_JSON='[]'

source "$HOME/.config/sketchybar/icon_map.sh"

for ws in "${WORKSPACES[@]}"; do
  SPACE_INDEX="$(jq -r --arg ws "$ws" 'first(.[] | select(.label == $ws or ((.index|tostring) == $ws)) | .index) // empty' <<< "$SPACES_JSON")"

  if [ -z "$SPACE_INDEX" ]; then
    continue
  fi

  APP_NAME="$(jq -r --argjson sid "$SPACE_INDEX" 'map(select(.space == $sid)) | map(.app) | map(select(. != null and . != "")) | first // empty' <<< "$WINDOWS_JSON")"

  if [ -n "$APP_NAME" ]; then
    __icon_map "$APP_NAME"
    ICON_VALUE="${icon_result:-:default:}"
    ICON_FONT="sketchybar-app-font:Regular:14.0"
  else
    ICON_VALUE="$ws"
    ICON_FONT="Hack Nerd Font:Bold:14.0"
  fi

  HAS_FOCUS="$(jq -r --argjson sid "$SPACE_INDEX" 'first(.[] | select(.index == $sid) | ."has-focus") // false' <<< "$SPACES_JSON")"

  if [ "$HAS_FOCUS" = "true" ]; then
    BG_COLOR="0x00000000"
    ICON_COLOR="0xffff69b4"
    LABEL_COLOR="0xffff69b4"
  else
    BG_COLOR="0x00000000"
    ICON_COLOR="0xffffffff"
    LABEL_COLOR="0xffffffff"
  fi

  sketchybar --set "space.$ws" \
    icon="$ICON_VALUE" \
    icon.font="$ICON_FONT" \
    background.color="$BG_COLOR" \
    icon.color="$ICON_COLOR" \
    label.color="$LABEL_COLOR"
done
