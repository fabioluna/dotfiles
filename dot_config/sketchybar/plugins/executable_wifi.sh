#!/usr/bin/env bash
#
# show SSID and approximate signal % (macOS)

# interface might be en0 or en1, adjust if needed
IF="en0"

ssid=$(networksetup -getairportnetwork $IF | sed 's/^Current Wi-Fi Network: //')
rssi=$( /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I \
         | awk '/agrCtlRSSI/ {print $2}' )

# map RSSI (–100…0) → 0…100%
pct=$(( (rssi + 100) * 100 / 50 ))
(( pct<0 )) && pct=0
(( pct>100 )) && pct=100

echo "$ssid (${pct}%)"
