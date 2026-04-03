#!/usr/bin/env bash

LOCATION_FILE="$HOME/.config/sketchybar/weather_location"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar"
CACHE_FILE="$CACHE_DIR/weather_last_success.json"
LOCK_DIR="$CACHE_DIR/weather_fetch.lock"
MIN_FETCH_INTERVAL_SEC="${WEATHER_MIN_FETCH_INTERVAL_SEC:-10800}"

mkdir -p "$CACHE_DIR"

pick_icon() {
  case "$1" in
    113) echo "☀️" ;;
    116|119|122) echo "☁️" ;;
    143|248|260) echo "🌫" ;;
    176|263|266|293|296|299|302|305|308|353|356|359) echo "🌧" ;;
    179|182|185|227|230|281|284|311|314|317|320|323|326|329|332|335|338|362|365|368|371|374|377) echo "❄️" ;;
    200|386|389|392|395) echo "⛈" ;;
    *) echo "🌡" ;;
  esac
}

fetch_json() {
  curl -fsS --retry 2 --retry-delay 1 --retry-all-errors --connect-timeout 3 --max-time 12 "$1" 2>/dev/null
}

safe_now_epoch() {
  date +%s 2>/dev/null || printf '0\n'
}

parse_cache() {
  [ -f "$CACHE_FILE" ] || return 1

  CACHE_FETCHED_AT="$(jq -r '.fetched_at // empty' < "$CACHE_FILE" 2>/dev/null)"
  CACHE_TEMP_C="$(jq -r '.temp_c // empty' < "$CACHE_FILE" 2>/dev/null)"
  CACHE_CODE="$(jq -r '.code // empty' < "$CACHE_FILE" 2>/dev/null)"
  CACHE_CITY="$(jq -r '.city // empty' < "$CACHE_FILE" 2>/dev/null)"

  [ -n "$CACHE_FETCHED_AT" ] && [ -n "$CACHE_TEMP_C" ]
}

set_label_from_cache() {
  if parse_cache; then
    sketchybar --set "$NAME" label="$(render_label "$CACHE_TEMP_C" "$CACHE_CODE" "$CACHE_CITY")"
    return 0
  fi

  return 1
}

render_label() {
  local temp_c="$1"
  local code="$2"
  local city="$3"
  local icon

  icon="$(pick_icon "$code")"

  if [ -n "$city" ] && [[ "$city" != "not found"* ]]; then
    printf '%s %s %s\n' "$city" "$icon" "${temp_c}°C"
  else
    printf '%s %s\n' "$icon" "${temp_c}°C"
  fi
}

write_cache() {
  local fetched_at="$1"
  local temp_c="$2"
  local code="$3"
  local city="$4"

  jq -n \
    --arg fetched_at "$fetched_at" \
    --arg temp_c "$temp_c" \
    --arg code "$code" \
    --arg city "$city" \
    '{fetched_at: ($fetched_at | tonumber), temp_c: $temp_c, code: $code, city: $city}' \
    > "$CACHE_FILE" 2>/dev/null
}

fetch_ip_geo() {
  local geo

  geo="$(fetch_json "https://ipapi.co/json/")"
  if [ -n "$geo" ]; then
    local lat lon city country
    lat="$(jq -r '.latitude // empty' <<< "$geo")"
    lon="$(jq -r '.longitude // empty' <<< "$geo")"
    city="$(jq -r '.city // empty' <<< "$geo")"
    country="$(jq -r '.country_name // empty' <<< "$geo")"
    if [ -n "$lat" ] && [ -n "$lon" ]; then
      printf '%s|%s|%s|%s\n' "$lat" "$lon" "$city" "$country"
      return 0
    fi
  fi

  geo="$(fetch_json "https://ipinfo.io/json")"
  if [ -n "$geo" ]; then
    local loc city country
    loc="$(jq -r '.loc // empty' <<< "$geo")"
    city="$(jq -r '.city // empty' <<< "$geo")"
    country="$(jq -r '.country // empty' <<< "$geo")"
    if [ -n "$loc" ] && [[ "$loc" == *,* ]]; then
      printf '%s|%s|%s\n' "$loc" "$city" "$country"
      return 0
    fi
  fi

  return 1
}

LOCATION_OVERRIDE=""
if [ -f "$LOCATION_FILE" ]; then
  LOCATION_OVERRIDE="$(head -n 1 "$LOCATION_FILE" | tr -d '\r')"
fi

NOW_EPOCH="$(safe_now_epoch)"

if parse_cache; then
  CACHE_AGE=$((NOW_EPOCH - CACHE_FETCHED_AT))
  if [ "$CACHE_AGE" -ge 0 ] && [ "$CACHE_AGE" -lt "$MIN_FETCH_INTERVAL_SEC" ]; then
    set_label_from_cache
    exit 0
  fi
fi

LOCK_ACQUIRED=0
if mkdir "$LOCK_DIR" 2>/dev/null; then
  LOCK_ACQUIRED=1
else
  for _ in {1..10}; do
    sleep 0.5
    if set_label_from_cache; then
      exit 0
    fi
  done

  LOCK_MTIME="$(stat -f %m "$LOCK_DIR" 2>/dev/null || printf '0\n')"
  LOCK_AGE=$((NOW_EPOCH - LOCK_MTIME))
  if [ "$LOCK_AGE" -gt 300 ]; then
    rmdir "$LOCK_DIR" 2>/dev/null || true
    if mkdir "$LOCK_DIR" 2>/dev/null; then
      LOCK_ACQUIRED=1
    fi
  fi
fi

if [ "$LOCK_ACQUIRED" -eq 1 ]; then
  trap 'rmdir "$LOCK_DIR" 2>/dev/null || true' EXIT
fi

TIMEZONE_CITY=""
TIMEZONE_PATH="$(readlink /etc/localtime 2>/dev/null || true)"
if [[ "$TIMEZONE_PATH" == *"/zoneinfo/"* ]]; then
  TIMEZONE_NAME="${TIMEZONE_PATH##*/zoneinfo/}"
  TIMEZONE_CITY="${TIMEZONE_NAME##*/}"
  TIMEZONE_CITY="${TIMEZONE_CITY//_/ }"
fi

IP_COORDS=""
IP_CITY=""
IP_COUNTRY=""

if [ -z "$LOCATION_OVERRIDE" ]; then
  if IP_GEO="$(fetch_ip_geo)"; then
    IFS='|' read -r geo_a geo_b geo_c geo_d <<< "$IP_GEO"
    if [ -n "$geo_d" ]; then
      IP_COORDS="$geo_a,$geo_b"
      IP_CITY="$geo_c"
      IP_COUNTRY="$geo_d"
    else
      IP_COORDS="$geo_a"
      IP_CITY="$geo_b"
      IP_COUNTRY="$geo_c"
    fi
  fi
fi

if [ -n "$LOCATION_OVERRIDE" ]; then
  LOCATION_QUERY="$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))' "$LOCATION_OVERRIDE" 2>/dev/null)"
  WEATHER_JSON="$(fetch_json "https://wttr.in/${LOCATION_QUERY}?format=j1")"
elif [ -n "$IP_COORDS" ]; then
  WEATHER_JSON="$(fetch_json "https://wttr.in/${IP_COORDS}?format=j1")"
elif [ -n "$TIMEZONE_CITY" ]; then
  LOCATION_QUERY="$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))' "$TIMEZONE_CITY" 2>/dev/null)"
  WEATHER_JSON="$(fetch_json "https://wttr.in/${LOCATION_QUERY}?format=j1")"
else
  WEATHER_JSON="$(fetch_json "https://wttr.in/?format=j1")"
fi

if [ -z "$WEATHER_JSON" ]; then
  set_label_from_cache || true
  exit 0
fi

TEMP_C="$(jq -r '.current_condition[0].temp_C // empty' <<< "$WEATHER_JSON")"
CODE="$(jq -r '.current_condition[0].weatherCode // empty' <<< "$WEATHER_JSON")"
CITY="$(jq -r '.nearest_area[0].areaName[0].value // empty' <<< "$WEATHER_JSON")"

if [ -n "$LOCATION_OVERRIDE" ]; then
  CITY="$LOCATION_OVERRIDE"
elif [ -n "$IP_CITY" ]; then
  CITY="$IP_CITY"
elif [ -n "$TIMEZONE_CITY" ]; then
  CITY="$TIMEZONE_CITY"
fi

ICON="$(pick_icon "$CODE")"

if [ -z "$TEMP_C" ]; then
  set_label_from_cache || true
  exit 0
fi

write_cache "$NOW_EPOCH" "$TEMP_C" "$CODE" "$CITY"

if [ -n "$CITY" ] && [[ "$CITY" != "not found"* ]]; then
  WEATHER_LABEL="$CITY $ICON ${TEMP_C}°C"
else
  WEATHER_LABEL="$ICON ${TEMP_C}°C"
fi

sketchybar --set "$NAME" label="$WEATHER_LABEL"
