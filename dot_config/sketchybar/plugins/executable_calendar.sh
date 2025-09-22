#!/bin/sh

# Calendar popup script for SketchyBar
# This script creates a calendar view with the current month and highlights today

# Get current date information
current_month=$(date +%m)
current_year=$(date +%Y)
current_day=$(date +%d)
today_full=$(date +'%a %d %b %Y')

# Remove leading zero from current_day for comparison
current_day_clean=$(echo "$current_day" | sed 's/^0*//')

# Function to create calendar items for the popup
create_calendar_popup() {
    # Remove any existing calendar popup items (suppress error output)
    sketchybar --remove '/calendar\..*/' 2>/dev/null || true
    
    # Calendar header with current month/year
    month_year=$(date +'%B %Y')
    sketchybar --add item calendar.header popup.clock \
               --set calendar.header label="📅 $month_year" \
                                   label.font="Hack Nerd Font:Bold:16.0" \
                                   label.color=0xffffffff \
                                   label.padding_left=15 \
                                   label.padding_right=15 \
                                   background.drawing=off \
                                   icon.drawing=off
    
    # Get calendar output and process it
    cal_output=$(cal "$current_month" "$current_year")
    
    # Add weekday headers (second line of cal output)
    weekdays=$(echo "$cal_output" | sed -n '2p')
    sketchybar --add item calendar.weekdays popup.clock \
               --set calendar.weekdays label="$weekdays" \
                                      label.font="Hack Nerd Font:Bold:12.0" \
                                      label.color=0xffcccccc \
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
            # Highlight today's date with background color
            if echo "$line" | grep -q "\b$current_day_clean\b"; then
                highlighted_line=$(echo "$line" | sed "s/\b$current_day_clean\b/◉$current_day_clean◉/")
                line="$highlighted_line"
            fi
            
            sketchybar --add item "calendar.week$week_num" popup.clock \
                       --set "calendar.week$week_num" label="$line" \
                                                       label.font="SF Mono:Regular:13.0" \
                                                       label.color=0xffffffff \
                                                       label.padding_left=15 \
                                                       label.padding_right=15 \
                                                       background.drawing=off \
                                                       icon.drawing=off
            week_num=$((week_num + 1))
        fi
    done
    # Restore IFS
    IFS="$OLD_IFS"
    
    # Add separator
    sketchybar --add item calendar.separator popup.clock \
               --set calendar.separator label="━━━━━━━━━━━━━━━━━━━━━━━━━━" \
                                       label.font="Hack Nerd Font:Regular:10.0" \
                                       label.color=0xff666666 \
                                       label.padding_left=15 \
                                       label.padding_right=15 \
                                       background.drawing=off \
                                       icon.drawing=off
    
    # Add current time
    current_time=$(date +'🕐 %H:%M:%S')
    sketchybar --add item calendar.time popup.clock \
               --set calendar.time label="$current_time" \
                                   label.font="Hack Nerd Font:Bold:14.0" \
                                   label.color=0xff00ff88 \
                                   label.padding_left=15 \
                                   label.padding_right=15 \
                                   background.drawing=off \
                                   icon.drawing=off
    
    # Add today's full date
    sketchybar --add item calendar.today popup.clock \
               --set calendar.today label="📆 $today_full" \
                                    label.font="Hack Nerd Font:Regular:12.0" \
                                    label.color=0xffaaaaaa \
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
        sketchybar --set clock popup.drawing=on
    fi
else
    # Default: just update the clock display
    sketchybar --set "$NAME" label="$(date +'%a %d %b %H:%M')"
fi