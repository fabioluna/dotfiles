#!/usr/bin/env bash
# front_app.sh

# 1) Get frontmost app name
APP_NAME=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

# 2) Source the icon-map helper
source "$HOME/.config/sketchybar/icon_map.sh"

# 3) Try the community icon font
__icon_map "$APP_NAME"
ICON_LIGATURE="$icon_result"

if [[ -n "$ICON_LIGATURE" ]]; then
  # Use the mapped ligature glyph
  sketchybar --set front_app icon="$ICON_LIGATURE" label="$APP_NAME"

else
  # 4) Fallback to SF Symbol if you know one
  # e.g. pick a generic glyph name or derive from the bundle, 
  # here we use "app" as a catch-all
  sketchybar --set front_app icon="app" icon.font="SF Pro" label="$APP_NAME"
fi

# #!/bin/bash
#
# APP_NAME="$INFO"
# APP_ICON=$(osascript -e "tell application \"System Events\" to get the file of application process \"$APP_NAME\"" \
#            -e "POSIX path of result" \
#            -e "do shell script \"sips -s format icns \\\"\" & result & \"\\\" --out /tmp/icon.icns >/dev/null 2>&1 && echo /tmp/icon.icns\"")
#
# sketchybar --set $NAME label="$APP_NAME" icon="$APP_ICON"
