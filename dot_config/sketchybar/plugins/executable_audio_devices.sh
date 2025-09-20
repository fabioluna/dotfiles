#!/usr/bin/env bash

get_short_name() {
  local name="$1"
  case "$name" in
    *"MacBook Pro Speakers"*) echo "💻" ;;
    *"MacBook Pro Microphone"*) echo "💻" ;;
    *"QCY"*) echo "QCY" ;;
    *"USB Audio"*) echo "USB" ;;
    *"Multi-Output"*) echo "Multi" ;;
    *) echo "${name:0:6}" ;;
  esac
}

current_output=$(SwitchAudioSource -c)
output_short=$(get_short_name "$current_output")

sketchybar --set audio_devices label="$output_short"