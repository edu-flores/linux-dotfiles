#!/bin/bash

# File to store the month difference
tmp_file="/tmp/calendar_month_diff"

# Determine month difference based on the argument
case $1 in
    "next")
        month_diff=$(($(cat $tmp_file 2> /dev/null) + 1))
        ;;
    "prev")
        month_diff=$(($(cat $tmp_file 2> /dev/null) - 1))
        ;;
    *)
        month_diff=0
        ;;
esac

# Store the month difference for next/prev
echo "$month_diff" > $tmp_file

# Get the calendar for the specified month
if [ $month_diff -eq 0 ]; then
    today=$(date "+%e")
    calendar=$(cal | sed "1n; 0,/$today/{s/$today/<u><b>&<\/b><\/u>/}")  # Highlight today
else
    calendar=$(cal $(date -d "$month_diff months" "+%m %Y"))
fi

# Show notification
HEAD=$(echo "$calendar" | head -n +1)
BODY=$(echo "$calendar" | tail -n +2)
FOOT="\n  Calendar"
dunstify "$HEAD" "$BODY$FOOT" -u critical -r -1
