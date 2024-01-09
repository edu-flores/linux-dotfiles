#!/bin/bash

# Open layouts
for i in {1..5}; do
    i3-msg "workspace $i; append_layout ~/.config/i3/layouts/$i.json"
done

# Execute applications
# Workspace 1
google-chrome-stable &

# Workspace 2
code &

# Workspace 3
alacritty --title "Media Player" -e sh -c "ncspot" &
alacritty --title "Audio Visualizer" -e sh -c "cava" &
alacritty --title "Lyrics" -e sh -c "sptlrx" &

# Workspace 4
alacritty --title "File Manager" -e sh -c "ranger" &
alacritty --title "System Monitor" -e sh -c "btm" &
alacritty --title "System Information" -e sh -c "neofetch; zsh" &
alacritty --title "Clock" -e sh -c "tty-clock -c -t -s -C 6 -B -f '%A, %d %B %Y'" &
alacritty --title "Pipes" -e sh -c "pipes.sh -f 20" &
alacritty --title "Matrix" -e sh -c "cmatrix -u 9" &

# Workspace 5
xpad &

# Scratchpad
alacritty --title "Scratchpad" &
