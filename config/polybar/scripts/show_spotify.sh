#!/bin/bash

# Shorten the result string in case it's too long
get_truncated_string() {
    local input=$1
    local max_length=$2
    local result=$(echo "$input" | cut -c 1-$max_length)
    if [ ${#input} -gt $max_length ]; then
        result+="..."
    fi
    echo "$result"
}

# Song title
title=$(playerctl --player=ncspot metadata --format "{{ title }}")
truncated_title=$(get_truncated_string "$title" 15)

# Artist
artist=$(playerctl --player=ncspot metadata --format "{{ artist }}")
truncated_artist=$(get_truncated_string "$artist" 15)

# File where the condition is stored
tmp_file="/tmp/spotify_status"

# Display the result depending on the spotify status
if ! [ -f "$tmp_file" ] || [ "$(cat $tmp_file 2> /dev/null)" = "exposed" ]; then
    echo "$truncated_title - $truncated_artist"
else
    full_name=$(getent passwd $USER | cut -d ':' -f 5)
    if [ -z "$full_name" ]; then
        echo "Please configure your full name"
    else
        echo "$full_name"
    fi
fi
