#!/usr/bin/env bash

get_output_icon() {
  local name="$1"

  case "$name" in
    *"MacBook Pro Speakers"*|*"Built-in Output"*|*"Internal Speakers"*) echo "💻" ;;
    *"AirPods"*|*"Pods"*|*"Headphones"*|*"QCY"*|*"WH-"*|*"Bose"*|*"Sony"*) echo "🎧" ;;
    *"USB Audio"*|*"USB"*|*"DAC"*) echo "🔌" ;;
    *"Multi-Output"*) echo "🎚️" ;;
    *"HDMI"*|*"Display"*|*"Monitor"*|*"LG"*|*"DELL"*|*"BenQ"*) echo "🖥️" ;;
    *) echo "🔊" ;;
  esac
}

current_output="$(SwitchAudioSource -c 2>/dev/null)"
[ -z "$current_output" ] && current_output="Unknown"

output_icon="$(get_output_icon "$current_output")"

sketchybar --set "$NAME" icon="$output_icon" label="" label.drawing=off
