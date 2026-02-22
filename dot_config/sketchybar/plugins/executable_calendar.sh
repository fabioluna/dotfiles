#!/bin/sh

# Calendar popup script for SketchyBar
# This script creates a calendar view with the current month and highlights today
# Using Rose Pine color theme

# Source Rose Pine colors (convert from Lua to shell variables)
# Rose Pine colors in hex format
ROSE_PINE_BASE="0xff191724"
ROSE_PINE_SURFACE="0xff1f1d2e"
ROSE_PINE_OVERLAY="0xff26233a"
ROSE_PINE_MUTED="0xff6e6a86"
ROSE_PINE_SUBTLE="0xff908caa"
ROSE_PINE_TEXT="0xffe0def4"
ROSE_PINE_LOVE="0xffeb6f92"
ROSE_PINE_GOLD="0xfff6c177"
ROSE_PINE_ROSE="0xffebbcba"
ROSE_PINE_PINE="0xff31748f"
ROSE_PINE_FOAM="0xff9ccfd8"
ROSE_PINE_IRIS="0xffc4a7e7"

# Get current date information
current_month=$(date +%m)
current_year=$(date +%Y)
current_day=$(date +%d)
today_full=$(date +'%a %d %b %Y')

# Remove leading zero from current_day for comparison
current_day_clean=$(echo "$current_day" | sed 's/^0*//')

# Function to create calendar items for the popup
# Function to create calendar items for the popup
create_calendar_popup() {
    # Remove any existing calendar popup items (suppress error output)
    sketchybar --remove '/calendar\..*/' 2>/dev/null || true

    # Set popup background to be solid and topmost
    sketchybar --set clock popup.background.color="$ROSE_PINE_BASE" \
        popup.background.corner_radius=12 \
        popup.background.border_width=2 \
        popup.background.border_color="$ROSE_PINE_OVERLAY"

    # Get calendar output first
    cal_output=$(cal "$current_month" "$current_year")

    # Calendar header with current month/year
    month_year=$(date +'%B %Y')
    sketchybar --add item calendar.header popup.clock \
        --set calendar.header label="📅 $month_year" \
        label.font="Hack Nerd Font:Bold:16.0" \
        label.color="$ROSE_PINE_TEXT" \
        label.padding_left=15 \
        label.padding_right=15 \
        background.drawing=on \
        background.color="$ROSE_PINE_OVERLAY" \
        background.corner_radius=8 \
        icon.drawing=off

    # Add weekday headers (second line of cal output)
    weekdays=$(echo "$cal_output" | sed -n '2p')
    sketchybar --add item calendar.weekdays popup.clock \
        --set calendar.weekdays label="$weekdays" \
        label.font="SF Mono:Bold:13.0" \
        label.color="$ROSE_PINE_IRIS" \
        label.padding_left=15 \
        label.padding_right=15 \
        background.drawing=off \
        icon.drawing=off

    # Process calendar weeks (skip first two lines: month/year and weekdays)
    week_lines=$(echo "$cal_output" | tail -n +3)
    week_num=1
    # Save IFS and set to newline only
    OLD_IFS="$IFS"
    IFS='
'
    for line in $week_lines; do
        if [ -n "$line" ] && [ "$week_num" -le 6 ]; then
            # Highlight today's date with Rose Pine love color
            # Highlight today's date with Rose Pine love color
            if echo "$line" | grep -q "\b$current_day_clean\b"; then
                highlighted_line=$(echo "$line" | sed "s/\b$current_day_clean\b/● $current_day_clean ●/")
                sketchybar --add item "calendar.week$week_num" popup.clock \
                    --set "calendar.week$week_num" label="$highlighted_line" \
                    label.font="SF Mono:Bold:13.0" \
                    label.color="$ROSE_PINE_BASE" \
                    label.padding_left=15 \
                    label.padding_right=15 \
                    background.drawing=on \
                    background.color="$ROSE_PINE_SURFACE" \
                    background.corner_radius=4 \
                    background.color="$ROSE_PINE_LOVE" \
                    background.corner_radius=6 \
                    icon.drawing=off
            else
                sketchybar --add item "calendar.week$week_num" popup.clock \
                    --set "calendar.week$week_num" label="$line" \
                    label.font="SF Mono:Regular:13.0" \
                    label.color="$ROSE_PINE_TEXT" \
                    label.padding_left=15 \
                    label.padding_right=15 \
                    background.drawing=off \
                    icon.drawing=off
            fi
            week_num=$((week_num + 1))
        fi
    done
    # Restore IFS
    IFS="$OLD_IFS"

    # Add separator with Rose Pine styling
    sketchybar --add item calendar.separator popup.clock \
        --set calendar.separator label="━━━━━━━━━━━━━━━━━━━━━━━━━━" \
        label.font="Hack Nerd Font:Regular:10.0" \
        label.color="$ROSE_PINE_MUTED" \
        label.padding_left=15 \
        label.padding_right=15 \
        background.drawing=off \
        icon.drawing=off

    # Add current time with Rose Pine foam color
    current_time=$(date +'🕐 %H:%M:%S')
    sketchybar --add item calendar.time popup.clock \
        --set calendar.time label="$current_time" \
        label.font="Hack Nerd Font:Bold:14.0" \
        label.color="$ROSE_PINE_FOAM" \
        label.padding_left=15 \
        label.padding_right=15 \
        background.drawing=off \
        icon.drawing=off

    # Add today's full date with Rose Pine gold color
    sketchybar --add item calendar.today popup.clock \
        --set calendar.today label="📆 $today_full" \
        label.font="Hack Nerd Font:Regular:12.0" \
        label.color="$ROSE_PINE_GOLD" \
        label.padding_left=15 \
        label.padding_right=15 \
        background.drawing=off \
        icon.drawing=off
}

# Toggle popup
if [ "$1" = "toggle" ]; then
    # Check if popup is currently shown by querying the clock item
    popup_state=$(sketchybar --query clock | jq -r '.popup.drawing // "off"')

    if [ "$popup_state" = "on" ]; then
        # Hide popup
        sketchybar --set clock popup.drawing=off
        # Clean up popup items
        sketchybar --remove '/calendar\..*/' 2>/dev/null || true
    else
        # Show popup - first create the calendar items, then show the popup
        create_calendar_popup
        sketchybar --set clock popup.drawing=on popup.topmost=on
    fi
else
    # Default: just update the clock display
    sketchybar --set "$NAME" label="$(date +'%a %d %b %H:%M')"
fi
