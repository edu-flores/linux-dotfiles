#!/bin/bash

# Pick a theme
current_hour=$(date +%H)
case $current_hour in
    08|09|10|11) theme="everforest" ;;
    12|13|14|15) theme="nord" ;;
    16|17|18|19) theme="gruvbox" ;;
    20|21|22|23|00|01|02|03|04|05|06|07) theme="dracula" ;;
esac

# For testing purposes
if [ -n "$1" ]; then
    case $1 in
        1) theme="everforest" ;;
        2) theme="nord" ;;
        3) theme="gruvbox" ;;
        4) theme="dracula" ;;
        *) echo "Invalid theme selection. Choose 1 for Everforest, 2 for Nord, 3 for Gruvbox, or 4 for Dracula." && return 1 ;;
    esac
fi

# Set variables
case $theme in
    everforest)
        wallpaper="everforest-wallpaper.png"
        background="#1e2326"
        background_alt="#4f5b58"
        foreground="#d3c6aa"
        vscode_theme="Everforest Dark"
        ;;
    nord)
        wallpaper="nord-wallpaper.png"
        background="#2e3440"
        background_alt="#4c566a"
        foreground="#d1dbe5"
        vscode_theme="Nord Deep"
        ;;
    gruvbox)
        wallpaper="gruvbox-wallpaper.png"
        background="#1d2021"
        background_alt="#3c3836"
        foreground="#ebdbb2"
        vscode_theme="Gruvbox Material Dark"
        ;;
    dracula)
        wallpaper="dracula-wallpaper.png"
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

# Dunst
pkill dunst
sed -i "s/background = \".*\"/background = \"$background_alt\"/" ~/.config/dunst/dunstrc

# VSCode
sed -i "s/\"workbench\.colorTheme\": \".*\",/\"workbench.colorTheme\": \"$vscode_theme\",/" ~/.config/Code/User/settings.json

# Wallpaper
sleep 0.5 && feh --bg-fill ~/Pictures/Wallpapers/$wallpaper
