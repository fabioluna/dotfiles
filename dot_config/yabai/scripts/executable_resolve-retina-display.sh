#!/usr/bin/env sh

DISPLAY_SELECTOR="${1:-}"

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

if [ -n "$DISPLAY_SELECTOR" ] && [ "$DISPLAY_SELECTOR" != "auto" ] && yabai -m query --displays | jq -e --arg idx "$DISPLAY_SELECTOR" '.[] | select((.index | tostring) == $idx)' >/dev/null 2>&1; then
  printf '%s\n' "$DISPLAY_SELECTOR"
  exit 0
fi

if command -v swift >/dev/null 2>&1; then
  retina_display_id="$(swift -e 'import CoreGraphics; import IOKit.graphics; var maxDisplays: UInt32 = 16; var activeDisplays = Array(repeating: CGDirectDisplayID(), count: Int(maxDisplays)); var displayCount: UInt32 = 0; let error = CGGetActiveDisplayList(maxDisplays, &activeDisplays, &displayCount); guard error == .success else { exit(1) }; for displayID in activeDisplays.prefix(Int(displayCount)) where CGDisplayIsBuiltin(displayID) != 0 { print(displayID); exit(0) }; exit(1)' 2>/dev/null | head -n 1)"
  if [ -n "$retina_display_id" ]; then
    retina_display_index="$(yabai -m query --displays | jq -r --arg id "$retina_display_id" '.[] | select((.id | tostring) == $id) | .index' | head -n 1)"
    if [ -n "$retina_display_index" ]; then
      printf '%s\n' "$retina_display_index"
      exit 0
    fi
  fi
fi

resolved_index="$(yabai -m query --displays | jq -r '.[0].index // empty' | head -n 1)"
if [ -n "$resolved_index" ]; then
  printf '%s\n' "$resolved_index"
  exit 0
fi

printf '1\n'
