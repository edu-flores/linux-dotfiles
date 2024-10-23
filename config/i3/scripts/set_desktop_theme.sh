#!/bin/bash

# List of available themes
themes=("everforest" "gruvbox" "tokyo" "nord")

# Pick a random theme if $1 is not passed
if [ -z "$1" ]; then
    theme=${themes[$RANDOM % ${#themes[@]}]}
else
    # Select a theme based on the user's choice
    case $1 in
        1) theme="everforest" ;;
        2) theme="gruvbox" ;;
        3) theme="tokyo" ;;
        4) theme="nord" ;;
        *) echo "Invalid theme selection. Choose 1 for Everforest, 2 for Gruvbox, 3 for Tokyo Night, or 4 for Nord." && exit 1 ;;
    esac
fi

# Set variables based on the selected theme
case $theme in
    everforest)
        background="#1d2021"
        background_alt="#414b50"
        foreground="#d3c6aa"
        vscode_theme="Everforest Dark"
        ;;
    gruvbox)
        background="#282828"
        background_alt="#504945"
        foreground="#ebdbb2"
        vscode_theme="Gruvbox Dark Medium"
        ;;
    tokyo)
        background="#1a1b26"
        background_alt="#3b4261"
        foreground="#c0caf5"
        vscode_theme="Tokyo Night Frameless"
        ;;
    nord)
        background="#2e3440"
        background_alt="#434c5e"
        foreground="#d8dee9"
        vscode_theme="Nord Deep"
        ;;
esac

# Change scratchpad title to avoid conflicts with i3
xdotool search --name "Scratchpad" set_window --name "Multiplexer"

# Polybar
sed -i "s/themes\/.*\.ini/themes\/$theme\.ini/" ~/.config/polybar/config.ini
~/.config/polybar/scripts/launch_polybar_program.sh

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
sed -i "s/\"workbench\.colorTheme\": \".*\"\s*/\"workbench.colorTheme\": \"$vscode_theme\"/" ~/.config/Code/User/settings.json

# Flameshot
printf "[General]\nuiColor=%s\ncontrastUiColor=%s\n" "$background_alt" "$background" > ~/.config/flameshot/flameshot.ini

# Obsidian
cat ~/Documents/Vault/.obsidian/snippets/$theme.css > ~/Documents/Vault/.obsidian/snippets/current.css

# Wallpaper
feh --bg-fill ~/Pictures/Wallpapers/$theme-wallpaper.png
