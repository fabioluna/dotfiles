#!/usr/bin/env bash
#
# measure B/s down ↑ up on en0 (macOS)

INTERFACE="en0"
TMP="/tmp/.sketchybar_net"

# get cumulative counters
read rx tx <<<$(netstat -bI $INTERFACE | awk 'NR==3 {print $7, $10}')

if [[ -f $TMP ]]; then
  read old_rx old_tx < $TMP
  drx=$(( (rx - old_rx) ))
  dtx=$(( (tx - old_tx) ))
else
  drx=0; dtx=0
fi

# save for next run
echo "$rx $tx" > $TMP

printf "↓%sB/s ↑%sB/s\n" "$drx" "$dtx"
