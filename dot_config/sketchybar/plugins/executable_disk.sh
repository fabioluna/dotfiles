#!/usr/bin/env bash
#
# show root-volume usage % (macOS & Linux)

use=$(df -h / | tail -1 | awk '{print $5}')
echo "$use"
