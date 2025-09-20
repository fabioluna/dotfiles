#!/usr/bin/env bash
# count unread in Apple Mail’s inbox
count=$(osascript -e 'tell application "Mail" to get unread count of inbox')
echo "$count"
