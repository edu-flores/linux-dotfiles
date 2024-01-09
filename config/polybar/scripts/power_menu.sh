#!/bin/bash

# Define power menu options
options="  POWER\n  REBOOT\n󰒲  SLEEP"

# Display Rofi menu and store the selected option
selected_option=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme-str '@import "power.rasi"')

# Perform actions based on the selected option
case "$selected_option" in
    "  POWER")
        systemctl poweroff
        ;;
    "  REBOOT")
        systemctl reboot
        ;;
    "󰒲  SLEEP")
        systemctl suspend
        ;;
    *)
        echo "Dismissed"
        ;;
esac
