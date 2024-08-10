#!/bin/bash

# Save current window
focused_window=$(xdotool getactivewindow)

# Take screenshot
flameshot gui > /dev/null

# Restore window
[ "$focused_window" == "$(xdotool getactivewindow)" ] && xdotool windowfocus $focused_window
