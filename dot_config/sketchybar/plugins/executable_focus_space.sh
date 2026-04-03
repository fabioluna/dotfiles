#!/usr/bin/env bash

TARGET="$1"

if [ -z "$TARGET" ]; then
  exit 0
fi

"$HOME/.config/yabai/scripts/focus-space-with-window.sh" "$TARGET" >/dev/null 2>&1 || true
