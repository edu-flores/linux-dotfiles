#!/bin/bash

# Save current window
focused_window=$(xdotool getactivewindow)

# Take screenshot
flameshot gui > /dev/null

# Restore window
if [ "$focused_window" == "$(xdotool getactivewindow)" ]
then
	xdotool windowfocus $focused_window
fi
