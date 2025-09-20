#!/usr/bin/env bash

# ─────────────────────────────────────────────────────────────────────────────
#  sketchybar :: config.sh
# ─────────────────────────────────────────────────────────────────────────────

#–– Bar defaults
sketchybar --bar system \
  background.color=0xff2c2e43 \
  background.corner_radius=6 \
  background.padding_left=12 \
  background.padding_right=12 \
  background.height=28 \
  icon.color=0xffabb2bf \
  label.color=0xffabb2bf

# ─────────────────────────────────────────────────────────────────────────────
#  LEFT ⟨ app shortcuts ⟩
# ─────────────────────────────────────────────────────────────────────────────

# Apple menu (example)
sketchybar --add item apple left                                      \
           --set apple    icon.font="Hack Nerd Font:Bold:14"         \
                       icon=                                       \
                       padding_left=6 padding_right=12               \
                       click_script="open -a /System/Applications/App\ Store.app"

# Finder
sketchybar --add item finder left                                     \
           --set finder   icon.font="Hack Nerd Font:Bold:14"         \
                       icon=󰉓                                       \
                       click_script="open -a Finder"

# Calendar
sketchybar --add item calendar left                                   \
           --set calendar icon.font="Hack Nerd Font:Regular:12"      \
                       icon=                                       \
                       label="$(date +'%b %d')"                      \
                       update_freq=3600

# Slack
sketchybar --add item slack left                                      \
           --set slack    icon.font="Hack Nerd Font:Bold:14"         \
                       icon=󰚥                                       \
                       click_script="open -a Slack"

# Messages
sketchybar --add item messages left                                   \
           --set messages icon.font="Hack Nerd Font:Bold:14"         \
                       icon=󰈭                                       \
                       click_script="open -a Messages"

# Spotify (or your player of choice)
sketchybar --add item spotify left                                    \
           --set spotify  icon.font="Hack Nerd Font:Bold:14"         \
                       icon=                                       \
                       click_script="open -a Spotify"

# sketchybar --add alias spotify_title spotify                            \
#            --set spotify_title drawing=off                              \
#                        script="$HOME/.config/sketchybar/plugins/now_playing.sh" \
#                        update_freq=2
#
# ─────────────────────────────────────────────────────────────────────────────
#  CENTER ⟨ now playing ⟩
# ─────────────────────────────────────────────────────────────────────────────

sketchybar --add item now_playing center                               \
           --set now_playing label.font="Hack Nerd Font:Regular:12"    \
                            script="$HOME/.config/sketchybar/plugins/now_playing.sh" \
                            update_freq=2

# ─────────────────────────────────────────────────────────────────────────────
#  RIGHT ⟨ system stats & date/time ⟩
# ─────────────────────────────────────────────────────────────────────────────

# Network bandwidth (down / up)
sketchybar --add item net right                                        \
           --set net      script="$HOME/.config/sketchybar/plugins/bandwidth.sh" \
                       update_freq=1                                    \
                       label.font="Hack Nerd Font:Regular:10"

# CPU usage
sketchybar --add item cpu right                                        \
           --set cpu      script="$HOME/.config/sketchybar/plugins/cpu.sh" \
                       update_freq=2                                    \
                       label.font="Hack Nerd Font:Regular:10"

# RAM usage
sketchybar --add item mem right                                        \
           --set mem      script="$HOME/.config/sketchybar/plugins/mem.sh" \
                       update_freq=5                                    \
                       label.font="Hack Nerd Font:Regular:10"

# Disk (SSD) usage
sketchybar --add item disk right                                       \
           --set disk     script="$HOME/.config/sketchybar/plugins/disk.sh" \
                       update_freq=60                                   \
                       label.font="Hack Nerd Font:Regular:10"

# WiFi SSID + signal %
sketchybar --add item wifi right                                       \
           --set wifi     script="$HOME/.config/sketchybar/plugins/wifi.sh" \
                       update_freq=10                                   \
                       label.font="Hack Nerd Font:Regular:10"

# Battery
sketchybar --add item battery right                                    \
           --set battery  script="$HOME/.config/sketchybar/plugins/battery.sh" \
                       update_freq=30                                   \
                       label.font="Hack Nerd Font:Regular:10"

# Date
sketchybar --add item date right                                       \
           --set date     label="$(date +'%a %d.%m.%Y')"               \
                       update_freq=60                                   \
                       label.font="Hack Nerd Font:Regular:10"

# Time
sketchybar --add item time right                                       \
           --set time     label="$(date +'%H:%M')"                     \
                       update_freq=30                                   \
                       label.font="Hack Nerd Font:Regular:10"
# # General Bar Settings
# sketchybar --bar \
#   height=30 \
#   color=0xff1e1e2e \
#   position=top \
#   blur_radius=20 \
#   corner_radius=10 \
#   padding_left=10 \
#   padding_right=10
#
# # Clock Item
# sketchybar --add item clock right
# sketchybar --set clock \
#   update_freq=1 \
#   script="date '+%Y-%m-%d %H:%M:%S'" \
#   label.color=0xffcdd6f4 \
#   label.font="SF Pro Text:Bold:14.0"
#
# # CPU Usage Item
# sketchybar --add item cpu right
# sketchybar --set cpu \
#   update_freq=5 \
#   script="top -l 1 | grep 'CPU usage' | awk '{print $3}'" \
#   label.color=0xffa6e3a1 \
#   label.font="SF Pro Text:Bold:14.0"
#
# # Wi-Fi Status Item
# sketchybar --add item wifi right
# sketchybar --set wifi \
#   update_freq=10 \
#   script="networksetup -getairportnetwork en0 | awk -F': ' '{print $2}'" \
#   label.color=0xff89b4fa \
#   label.font="SF Pro Text:Bold:14.0"
#
# # Volume Control Item
# sketchybar --add item volume right
# sketchybar --set volume \
#   update_freq=1 \
#   script="osascript -e 'output volume of (get volume settings)'" \
#   label.color=0xfff38ba8 \
#   label.font="SF Pro Text:Bold:14.0"
#
# # Separator
# sketchybar --add item separator right
# sketchybar --set separator \
#   label="|" \
#   label.color=0xff6c7086 \
#   label.font="SF Pro Text:Bold:14.0"
#
# # Spaces (Dynamic)
# # for i in {1..9}; do
# #   sketchybar --add space space.$i left
# #   sketchybar --set space.$i \
# #     label=$i \
# #     label.color=0xffcdd6f4 \
# #     label.font="SF Pro Text:Bold:14.0" \
# #     associated_space=$i
# # done
