#!/bin/bash

HISTORY_FILE=/tmp/rofi_history.txt

# Remove the history file if the user enters 'clear' as a command
if [[ "$(echo "$@" | awk '{print tolower($0)}')" == "clear" ]]; then
    rm $HISTORY_FILE
    echo "History cleared successfully."

# Notify the user that he entered a previous result as a command
elif [[ "$ROFI_RETV" == 1 ]]; then
    echo "Press [Ctrl + Enter] to override a highlighted result and enter your own input."

# Use libqalculate to get the result and save it to the history file
elif [[ "$#" -gt 0 && -n "$1" ]]; then
    result=$(qalc --terse "$@")
    echo "$@ = $result" >> $HISTORY_FILE
fi

# Echo the history file in reverse order
if [[ -e $HISTORY_FILE ]]; then
    tac $HISTORY_FILE
fi
