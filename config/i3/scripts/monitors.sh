#!/bin/bash

# Get primary and secondary monitors
PRIMARY_MONITOR=$1
SECONDARY_MONITOR=$2

# Configure dual monitor setup
if [ -n "$PRIMARY_MONITOR" ] && [ -n "$SECONDARY_MONITOR" ]; then
    xrandr --output "$SECONDARY_MONITOR" --rotate left \
           --left-of "$PRIMARY_MONITOR"
fi
