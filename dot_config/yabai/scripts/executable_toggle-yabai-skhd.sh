#!/usr/bin/env sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/service-state.sh"

YABAI_LABEL="com.asmvik.yabai"
SKHD_LABEL="com.koekeishiya.skhd"

gui_domain() {
  printf 'gui/%s\n' "$(id -u)"
}

service_target() {
  printf '%s/%s\n' "$(gui_domain)" "$1"
}

launch_agent_disabled() {
  case "$(launchctl print-disabled "$(gui_domain)" 2>/dev/null)" in
    *"\"$1\" => disabled"*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

launch_agent_state() {
  if launch_agent_disabled "$1"; then
    printf 'disabled\n'
  else
    printf 'enabled\n'
  fi
}

disable_launch_agent() {
  launchctl disable "$(service_target "$1")" >/dev/null 2>&1 || true
}

enable_launch_agent() {
  launchctl enable "$(service_target "$1")" >/dev/null 2>&1 || true
}

bootout_launch_agent() {
  launchctl bootout "$(service_target "$1")" >/dev/null 2>&1 || true
}

refresh_ui() {
  if command -v sketchybar >/dev/null 2>&1; then
    sketchybar --trigger spaces_refresh >/dev/null 2>&1 || true
  fi
}

ensure_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'missing command: %s\n' "$1" >&2
    exit 1
  fi
}

print_status() {
  desired="$(read_desired_state)"
  actual="$(actual_state)"
  yabai_launchd="$(launch_agent_state "$YABAI_LABEL")"
  skhd_launchd="$(launch_agent_state "$SKHD_LABEL")"
  printf 'desired=%s actual=%s yabai_launchd=%s skhd_launchd=%s\n' "$desired" "$actual" "$yabai_launchd" "$skhd_launchd"
}

start_services() {
  ensure_command yabai
  ensure_command skhd

  write_desired_state on
  enable_launch_agent "$YABAI_LABEL"
  enable_launch_agent "$SKHD_LABEL"
  yabai --start-service
  skhd --start-service
  refresh_ui
  print_status
}

stop_services() {
  write_desired_state off

  disable_launch_agent "$SKHD_LABEL"
  disable_launch_agent "$YABAI_LABEL"

  if command -v skhd >/dev/null 2>&1; then
    skhd --stop-service >/dev/null 2>&1 || true
  fi

  if command -v yabai >/dev/null 2>&1; then
    yabai --stop-service >/dev/null 2>&1 || true
  fi

  bootout_launch_agent "$SKHD_LABEL"
  bootout_launch_agent "$YABAI_LABEL"

  refresh_ui
  print_status
}

command_name="${1:-toggle}"

case "$command_name" in
  on|enable|start)
    start_services
    ;;
  off|disable|stop)
    stop_services
    ;;
  status)
    print_status
    ;;
  toggle)
    case "$(actual_state)" in
      on|partial)
        stop_services
        ;;
      off)
        start_services
        ;;
    esac
    ;;
  *)
    printf 'usage: %s [toggle|on|off|status]\n' "$0" >&2
    exit 1
    ;;
esac
