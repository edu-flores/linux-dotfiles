#!/bin/bash

# Pick a theme
current_hour=$(date +%H)
case $current_hour in
    07|08|09|10|11|12|13|14|15|16|17|18) theme="gruvbox" ;;
    19|20|21|22|23|00|01|02|03|04|05|06) theme="tokyo" ;;
esac

# For testing purposes
if [ -n "$1" ]; then
    case $1 in
        1) theme="everforest" ;;
        2) theme="gruvbox" ;;
        3) theme="tokyo" ;;
        4) theme="nord" ;;
        *) echo "Invalid theme selection. Choose 1 for Everforest, 2 for Gruvbox, 3 for Tokyo Night, or 4 for Nord." && return 1 ;;
    esac
fi

# Set variables
case $theme in
    everforest)
        wallpaper="everforest-wallpaper.png"
        background="#1d2021"
        background_alt="#4f5b58"
        foreground="#d3c6aa"
        vscode_theme="Everforest Dark"
        ;;
    gruvbox)
        wallpaper="gruvbox-wallpaper.png"
        background="#1d2021"
        background_alt="#32302f"
        foreground="#ebdbb2"
        vscode_theme="Gruvbox Dark Hard"
        ;;
    tokyo)
        wallpaper="tokyo-wallpaper.png"
        background="#1a1b26"
        background_alt="#323b5e"
        foreground="#a9b1d6"
        vscode_theme="Tokyo Night Frameless"
        ;;
    nord)
        wallpaper="nord-wallpaper.png"
        background="#2e3440"
        background_alt="#4c566a"
        foreground="#d1dbe5"
        vscode_theme="Nord Deep"
        ;;
esac

# Polybar
sed -i "s/themes\/.*\.ini/themes\/$theme\.ini/" ~/.config/polybar/config.ini
~/.config/polybar/scripts/launch_polybar.sh  # Reload status bar

# i3
sed -i "s/themes\/.*/themes\/$theme/" ~/.config/i3/config
i3 reload

# Dunst
pkill dunst
sed -i "s/background = \".*\"/background = \"$background_alt\"/" ~/.config/dunst/dunstrc
sed -i "s/foreground = \".*\"/foreground = \"$foreground\"/" ~/.config/dunst/dunstrc

# Alacritty
sed -i "s/themes\/.*\.toml/themes\/$theme\.toml/" ~/.config/alacritty/alacritty.toml

# Rofi
sed -i "s/themes\/.*\.rasi/themes\/$theme\.rasi/" ~/.config/rofi/config.rasi

# VSCode
sed -i "s/\"workbench\.colorTheme\": \".*\",/\"workbench.colorTheme\": \"$vscode_theme\",/" ~/.config/Code/User/settings.json

# Wallpaper
feh --bg-fill ~/Pictures/Wallpapers/$wallpaper
