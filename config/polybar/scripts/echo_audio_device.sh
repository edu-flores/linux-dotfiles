#!/bin/bash

# Load environment variables
source ~/.env

# Get current default audio sink
current_sink_name=$(pactl info | grep "Default Sink" | cut -d" " -f3)

# Echo icon
case $current_sink_name in
    $SPEAKERS)
        audio_icon="Speakers 󰓃";;
    $HEADPHONES)
        audio_icon="Headphones 󰋋";;
    *)
        audio_icon="Unknown ";;
esac

# Echo icon
echo $audio_icon
