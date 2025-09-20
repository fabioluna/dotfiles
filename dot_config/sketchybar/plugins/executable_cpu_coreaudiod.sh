#!/usr/bin/env bash
# show just the CPU% used by “coreaudiod”
cpu=$(ps -A -o %cpu,comm | awk '/coreaudiod/ { sum+=$1 } END { printf "%d%% coreaudiod\n", sum }')
echo "$cpu"
