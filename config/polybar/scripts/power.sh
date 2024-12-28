#!/bin/bash

# Define power menu options
options="⏼\n\n\n\n\n󰗽"

# Display Rofi menu and store the selected option
uptime=$(uptime -p | sed 's/up //')
selected_option=$(echo -e "$options" | rofi -dmenu -config ~/.config/rofi/power.rasi -mesg "System Uptime: $uptime")

# Perform actions based on the selected option
case "$selected_option" in
    "⏼")
        systemctl poweroff
        ;;
    "")
        systemctl reboot
        ;;
    "")
        systemctl suspend
        ;;
    "")
        systemctl hibernate
        ;;
    "")
        echo "Locked"
        ;;
    "󰗽")
        i3-msg exit
        ;;
    *)
        echo "Dismissed"
        ;;
esac
