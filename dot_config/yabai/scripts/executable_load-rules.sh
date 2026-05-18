#!/usr/bin/env sh

RETINA_SPACE_LABEL="${1:-retina}"
RETINA_SPACE_INDEX=11
APPS_ON_RETINA='^(Linear|Spotify|Todoist|Stickies|flstudio|Gather|slack|WhatsApp|Telegram|chat|ActivityMonitor|claude|Calendar)$'
RETINA_RULE_LABEL='apps-on-retina'
FLOAT_RULE_LABEL='always-float-apps'
FLOAT_APPS_FILE="$HOME/.config/yabai/always-float-apps.txt"
ALWAYS_FLOAT_APPS=''

build_regex_from_lines() {
  file_path="$1"
  pattern=''

  if [ ! -f "$file_path" ]; then
    return
  fi

  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      ''|'#'*)
        continue
        ;;
    esac

    if [ -n "$pattern" ]; then
      pattern="$pattern|$line"
    else
      pattern="$line"
    fi
  done < "$file_path"

  if [ -n "$pattern" ]; then
    printf '^(%s)$\n' "$pattern"
  fi
}

remove_rule_by_label() {
  rule_label="$1"

  if ! command -v jq >/dev/null 2>&1; then
    return
  fi

  yabai -m rule --list | jq -r --arg label "$rule_label" '.[] | select(.label == $label) | .index' | sort -rn | while IFS= read -r rule_index; do
    if [ -n "$rule_index" ]; then
      yabai -m rule --remove "$rule_index" >/dev/null 2>&1 || true
    fi
  done
}

if command -v jq >/dev/null 2>&1; then
  resolved_retina_index="$(yabai -m query --spaces | jq -r --arg label "$RETINA_SPACE_LABEL" '.[] | select(.label == $label) | .index' | head -n 1)"
  if [ -n "$resolved_retina_index" ]; then
    RETINA_SPACE_INDEX="$resolved_retina_index"
  fi
fi

ALWAYS_FLOAT_APPS="$(build_regex_from_lines "$FLOAT_APPS_FILE")"

remove_rule_by_label "$RETINA_RULE_LABEL"
remove_rule_by_label "$FLOAT_RULE_LABEL"

yabai -m rule --add label="$RETINA_RULE_LABEL" app="$APPS_ON_RETINA" space="$RETINA_SPACE_INDEX"
if [ -n "$ALWAYS_FLOAT_APPS" ]; then
  yabai -m rule --add label="$FLOAT_RULE_LABEL" app="$ALWAYS_FLOAT_APPS" manage=off
fi
