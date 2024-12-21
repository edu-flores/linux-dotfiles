#!/bin/bash

# Load environment variables
source ~/.env

# Get current default audio sink
current_sink_name=$(pactl info | grep "Default Sink" | cut -d" " -f3)

# Echo icon
case $current_sink_name in
    $SPEAKERS)
        audio_icon="󰓃";;
    $HEADPHONES)
        audio_icon="󰋋";;
    *)
        audio_icon="";;
esac

# Check if the sink is muted
if pactl get-sink-mute @DEFAULT_SINK@ | grep -q yes; then
    audio_icon="%{F#ff7043}󰝟%{F-}"
fi

# Output the result
echo $audio_icon
