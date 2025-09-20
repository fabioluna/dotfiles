#!/usr/bin/env bash

# Check if accessibility permission is granted
accessibility_check=$(osascript << 'EOF'
tell application "System Events"
    try
        tell process "Finder" to get name
        return "granted"
    on error
        return "denied"
    end try
end tell
EOF
)

if [[ "$accessibility_check" == "denied" ]]; then
    # Show instructions for enabling accessibility
    osascript << 'EOF'
display dialog "To use Signal Shifter integration:

1. Open System Preferences > Privacy & Security
2. Click 'Accessibility' in the left sidebar  
3. Click the lock and enter your password
4. Add 'sketchybar' or 'Terminal' to the list
5. Try clicking the audio icon again

For now, manually click the Signal Shifter icon in your menu bar." buttons {"Open Privacy Settings", "OK"} default button "Open Privacy Settings"
if button returned of result is "Open Privacy Settings" then
    do shell script "open 'x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility'"
end if
EOF
else
    # Try to click Signal Shifter's menu bar item
    osascript << 'EOF'
tell application "System Events"
    tell process "Signal Shifter"
        try
            click menu bar item 1 of menu bar 1
        on error errMsg
            try
                -- Try to find Signal Shifter by searching menu bar items
                set menuBarItems to menu bar items of menu bar 1
                repeat with i from 1 to count of menuBarItems
                    set menuBarItem to item i of menuBarItems
                    if (description of menuBarItem) contains "Signal" or (help of menuBarItem) contains "Signal" then
                        click menuBarItem
                        exit repeat
                    end if
                end repeat
            on error
                display notification "Could not find Signal Shifter menu item" with title "Audio Selector"
            end try
        end try
    end tell
end tell
EOF
fi