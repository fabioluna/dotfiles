#!/usr/bin/env bash
#
# show total CPU usage % (macOS)

# run top twice to get current snapshot
cpu=$(top -l 2 -n 0 | awk '/CPU usage/ {getline; getline; print}' \
      | tail -1 \
      | awk -F'[ %]+' '{print $3 + $5}')

printf "%.0f%%\n" "$cpu"
