#!/bin/bash

# Define power menu options
options="\n\n󰒲\n"

# Display Rofi menu and store the selected option
selected_option=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme-str '@import "power.rasi"')

# Perform actions based on the selected option
case "$selected_option" in
    "")
        systemctl poweroff
        ;;
    "")
        systemctl reboot
        ;;
    "󰒲")
        systemctl suspend
        ;;
    "")
        systemctl hibernate
        ;;
    *)
        echo "Dismissed"
        ;;
esac
