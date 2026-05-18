#!/usr/bin/env sh

RULE_FILE="$HOME/.config/yabai/always-float-apps.txt"

if [ ! -f "$RULE_FILE" ]; then
  exit 0
fi

while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    ''|'#'*)
      continue
      ;;
  esac

  printf '%s\n' "$line"
done < "$RULE_FILE"
