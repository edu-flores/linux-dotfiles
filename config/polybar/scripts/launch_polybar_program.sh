#!/bin/bash

# Terminate already running bar instances
# pkill -f "polybar top"
killall polybar

# Launch
# polybar top &
polybar -c ~/.config/polybar/polybar.ini main &
