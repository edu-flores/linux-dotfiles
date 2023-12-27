#!/bin/bash

# Open layouts
for i in {1..5}; do
    i3-msg "workspace $i; append_layout ~/.config/i3/layouts/$i.json"
done

# Execute applications
# Workspace 1
chromium &

# Workspace 2
code &
alacritty --title "Aux 1" &
alacritty --title "Aux 2" &

# Workspace 3
spotify &
alacritty --title "Audio Visualizer" -e sh -c "cava" &

# Workspace 4
alacritty --title "System Monitor" -e sh -c "btop" &
alacritty --title "System Information" -e sh -c "neofetch; zsh" &
alacritty --title "Clock" -e sh -c "tty-clock -t -c -B -C 7" &
alacritty --title "Bonsai" -e sh -c "cbonsai -l -i -t 0.2" &
alacritty --title "Pipes" -e sh -c "pipes -f 20" &
alacritty --title "Matrix" -e sh -c "cmatrix -u 9" &

# Workspace 5
xpad &

# Scratchpad
alacritty --title "Scratchpad" &
