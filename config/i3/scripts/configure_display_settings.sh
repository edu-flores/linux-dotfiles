#!/bin/bash

# Get displays
PRIMARY_MONITOR=$1
SECONDARY_MONITOR=$2

# Dual monitor setup
if [ -n "$SECONDARY_MONITOR" ] && [ -n "$PRIMARY_MONITOR" ]; then
    xrandr --output "$SECONDARY_MONITOR" --rotate left
    xrandr --output "$SECONDARY_MONITOR" --left-of "$PRIMARY_MONITOR"
fi
