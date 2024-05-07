#!/bin/bash

# Open layouts
for i in {1..5}; do
    i3-msg "workspace $i; append_layout ~/.config/i3/layouts/$i.json"
done

# Execute applications
# Workspace 1
google-chrome-stable &

# Workspace 2
spotify &

# Workspace 3
code &

# Workspace 4
alacritty --title "Clock" -e sh -c "tty-clock -c -t -s -C 6 -B -f '%A, %d %B %Y'" &
alacritty --title "File Manager" -e sh -c "ranger" &
alacritty --title "System Monitor" -e sh -c "btm" &
alacritty --title "Mixer" -e sh -c "pulsemixer" &
alacritty --title "Audio Visualizer" -e sh -c "cava" &

# Workspace 5
xpad &

# Scratchpad
alacritty --title "Scratchpad" -e sh -c "neofetch; zsh" &
