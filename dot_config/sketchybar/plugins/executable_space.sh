#!/usr/bin/env bash
#
# space.sh — highlight the current AeroSpace workspace

ITEM="$NAME"                    # e.g. "space.3"
WS="${ITEM#*.}"                 # extract "3"
FOCUS=$(aerospace list-workspaces --focused)

if [ "$WS" = "$FOCUS" ]; then
  # make the active workspace pop
  sketchybar --set "$ITEM" background.color=0xffff69b4
else
  # dim the others
  sketchybar --set "$ITEM" background.color=
fi
