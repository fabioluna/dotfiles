#!/usr/bin/env sh

STATE_DIR="$HOME/.config/yabai/state"
STATE_FILE="$STATE_DIR/enabled"

read_desired_state() {
  if [ ! -f "$STATE_FILE" ]; then
    printf 'on\n'
    return
  fi

  state="$(tr -d '[:space:]' < "$STATE_FILE")"
  case "$state" in
    off)
      printf 'off\n'
      ;;
    *)
      printf 'on\n'
      ;;
  esac
}

write_desired_state() {
  mkdir -p "$STATE_DIR"
  printf '%s\n' "$1" > "$STATE_FILE"
}

service_running() {
  pgrep -x "$1" >/dev/null 2>&1
}

actual_state() {
  yabai_running=0
  skhd_running=0

  if service_running yabai; then
    yabai_running=1
  fi

  if service_running skhd; then
    skhd_running=1
  fi

  if [ "$yabai_running" -eq 1 ] && [ "$skhd_running" -eq 1 ]; then
    printf 'on\n'
  elif [ "$yabai_running" -eq 0 ] && [ "$skhd_running" -eq 0 ]; then
    printf 'off\n'
  else
    printf 'partial\n'
  fi
}
