#!/usr/bin/env bash
#
# show RAM used % (macOS)

# free + inactive + speculative pages
pagesize=$(vm_stat | head -1 | awk '{print $8}')
free=$(vm_stat | awk '/Pages free/ {gsub("\\.","",$3); print $3}')
inactive=$(vm_stat | awk '/Pages inactive/ {gsub("\\.","",$3); print $3}')
spec=$(vm_stat | awk '/Pages speculative/ {gsub("\\.","",$3); print $3}')
used=$(( ( $(vm_stat | awk '/Pages active/ {gsub("\\.","",$3); print $3}') + inactive + spec ) * pagesize ))
used_mb=$(( used / 1024 / 1024 ))

total=$(sysctl -n hw.memsize)
total_mb=$(( total / 1024 / 1024 ))

percent=$(( used_mb * 100 / total_mb ))
echo "${percent}%"
