#!/bin/bash

# Define power menu options
options="\n\n\n\n\n󰩈"

# Display Rofi menu and store the selected option
selected_option=$(echo -e "$options" | rofi -dmenu -config ~/.config/rofi/power.rasi)

# Perform actions based on the selected option
case "$selected_option" in
    "")
        systemctl poweroff
        ;;
    "")
        systemctl reboot
        ;;
    "")
        systemctl suspend
        ;;
    "")
        systemctl hibernate
        ;;
    "")
        ~/.config/i3/scripts/lockscreen.sh
        ;;
    "󰩈")
        i3-msg exit
        ;;
    *)
        echo "Dismissed"
        ;;
esac
