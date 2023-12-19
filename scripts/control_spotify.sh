#!/bin/bash

get_truncated_string() {
    local input=$1
    local max_length=$2
    local result=$(echo "$input" | cut -c 1-$max_length)
    if [ ${#input} -gt $max_length ]; then
        result+="..."
    fi
    echo "$result"
}

title=$(playerctl --player=spotify metadata --format "{{ title }}")
truncated_title=$(get_truncated_string "$title" 20)

artist=$(playerctl --player=spotify metadata --format "{{ artist }}")
truncated_artist=$(get_truncated_string "$artist" 20)

echo "$truncated_title - $truncated_artist"
