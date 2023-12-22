#!/bin/bash

# Pick a theme
current_hour=$(date +%H)
case $current_hour in
    07|08|09|10|11|12|13) theme="everforest" ;;
    14|15|16|17|18) theme="gruvbox" ;;
    19|20|21|22|23|00|01|02|03|04|05|06) theme="dracula" ;;
esac

# For testing purposes
if [ -n "$1" ]; then
    case $1 in
        1) theme="gruvbox" ;;
        2) theme="everforest" ;;
        3) theme="dracula" ;;
        *) echo "Invalid theme selection. Choose 1 for Gruvbox, 2 for Everforest, or 3 for Dracula." && exit 1 ;;
    esac
fi

# Set variables
case $theme in
    gruvbox)
        wallpaper="City.jpg"
        background="#3c3836"
        background_alt="#1d2021"
        foreground="#ebdbb2"
        vscode_theme="Gruvbox Material Dark"
        ;;
    everforest)
        wallpaper="Forest.jpg"
        background="#1e2326"
        background_alt="#4f5b58"
        foreground="#d3c6aa"
        vscode_theme="Everforest Dark"
        ;;
    dracula)
        wallpaper="ElvishJungle.jpg"
        background="#282a36"
        background_alt="#44475a"
        foreground="#f8f8f2"
        vscode_theme="Dracula"
        ;;
esac

# Alacritty
sed -i "s/colors: \*.*/colors: \*$theme/" ~/.config/alacritty/alacritty.yml

# Rofi
sed -i "s/@theme \"~\/.config\/rofi\/themes\/.*\.rasi\"/@theme \"~\/.config\/rofi\/themes\/$theme.rasi\"/" ~/.config/rofi/config.rasi

# Polybar
sed -i "0,/background = .*/s/background = .*/background = $background/; 0,/background-alt = .*/s/background-alt = .*/background-alt = $background_alt/; 0,/foreground = .*/s/foreground = .*/foreground = $foreground/" ~/.config/polybar/config.ini
~/.config/polybar/scripts/launch_polybar.sh  # Launch polybar

# VSCode
sed -i "s/\"workbench\.colorTheme\": \".*\",/\"workbench.colorTheme\": \"$vscode_theme\",/" ~/.config/Code/User/settings.json

# Wallpaper
sleep 0.5 && feh --bg-fill ~/Pictures/Wallpapers/$wallpaper
