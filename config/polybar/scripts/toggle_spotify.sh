#!/bin/bash

# File to store the condition
tmp_file="/tmp/spotify_status"

# Toggle the condition
if ! [ -f "$tmp_file" ] || [ "$(cat $tmp_file 2> /dev/null)" = "exposed" ]; then
    echo "hidden" > $tmp_file
else
    echo "exposed" > $tmp_file
fi
