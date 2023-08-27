#!/bin/bash

# Ask the user for a value using rofi
selected_value=$(echo "" | rofi -dmenu -p "Enter a value:")

# If the user provided a value, apply it using your original command
if [ -n "$selected_value" ]; then
    dpi="$selected_value"
    echo "Applying DPI: $dpi"
    echo -e "Xft.dpi: ${dpi}\n" | xrdb -merge
fi
