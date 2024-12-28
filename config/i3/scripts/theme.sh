#!/bin/bash

# Toggle dark and light if no specific theme is passed
if [[ -z "$1" || "$1" = "toggle" ]]; then
    current_theme=$(awk '/@theme/ {print $2}' ~/.config/rofi/rofi.rasi | tr -d '"')
    [ "$current_theme" = "dark" ] && theme="light" || theme="dark"
else
    # Select a theme based on the user's choice
    case $1 in
        "light") theme="light" ;;
        "dark") theme="dark" ;;
        *) echo "Invalid theme selection." && exit 1 ;;
    esac
fi

# Set variables based on the selected theme
case $theme in
    light)
        gtk_theme="adw-gtk"
        background="#ffffff"
        foreground="#333333"
        notification_icon="weather-clear"
        notification_title="Light theme"
        ;;
    dark)
        gtk_theme="adw-gtk3-dark"
        background="#1e1e1e"
        foreground="#ffffff"
        notification_icon="weather-clear-night"
        notification_title="Dark theme"
        ;;
esac

# Polybar
sed -i "s/themes\/.*\.ini/themes\/$theme\.ini/" ~/.config/polybar/polybar.ini
source ~/.config/i3/scripts/polybar.sh

# i3
sed -i "s/themes\/.*/themes\/$theme/" ~/.config/i3/config
i3 reload

# Dunst
prev_pause_level=$(dunstctl get-pause-level) && pkill dunst
sed -i "s/background = \".*\"/background = \"$background\"/" ~/.config/dunst/dunstrc
sed -i "s/foreground = \".*\"/foreground = \"$foreground\"/" ~/.config/dunst/dunstrc
dunstctl set-pause-level $prev_pause_level

# Gtk
sed -i --follow-symlinks "s/Net\/ThemeName \".*\"/Net\/ThemeName \"$gtk_theme\"/" ~/.xsettingsd
pkill -HUP xsettingsd

# Alacritty
sed -i "s/themes\/.*\.toml/themes\/$theme\.toml/" ~/.config/alacritty/alacritty.toml

# Rofi
sed -i "s/@theme \".*\"/@theme \"$theme\"/" ~/.config/rofi/rofi.rasi
sed -i "s/@theme \".*\"/@theme \"$theme\"/" ~/.config/rofi/clipboard.rasi
sed -i "s/@theme \".*\"/@theme \"$theme\"/" ~/.config/rofi/power.rasi

# Flameshot
printf "[General]\nuiColor=%s\ncontrastUiColor=%s\n" "$background" "$foreground" > ~/.config/flameshot/flameshot.ini

# Send notification
dunstify --urgency="low" --icon="$notification_icon" "$notification_title"
