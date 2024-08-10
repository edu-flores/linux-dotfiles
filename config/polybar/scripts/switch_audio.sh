#!/bin/bash

# Get a list of available sink indices
sinks=($(pactl list short sinks | awk '{print $1}'))

# Get the name of the current default sink
current_sink_name=$(pactl info | grep "Default Sink:" | cut -d: -f2 | xargs)

# Find the current sink index in the list of available sinks
current_index=-1
for i in "${!sinks[@]}"; do
    sink_name=$(pactl list sinks | grep -e "Sink #"${sinks[$i]} -e "Name:" | grep -A1 "Sink #${sinks[$i]}" | grep "Name:" | cut -d: -f2 | xargs)
    if [ "$sink_name" = "$current_sink_name" ]; then
        current_index=$i
        break
    fi
done

if [ $current_index -eq -1 ]; then
    echo "Current default sink not found."
    exit 1
fi

# Calculate the next sink index
next_index=$(( (current_index + 1) % ${#sinks[@]} ))

# Set the next sink as the default
pactl set-default-sink "${sinks[$next_index]}"

echo "Switched default sink to ${sinks[$next_index]}"
