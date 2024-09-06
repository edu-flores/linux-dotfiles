#!/bin/bash

# Open layouts
for i in {1..5}; do
    i3-msg "workspace $i; append_layout ~/.config/i3/layouts/$i.json"
done

# Execute applications
# Workspace 1
google-chrome-stable &

# Workspace 2
alacritty --title "Spotify" -e zsh -c "ncspot" &
alacritty --title "Lyrics" -e zsh -c "sptlrx" &
alacritty --title "Audio Visualizer" -e zsh -c "cava" &

# Workspace 3
code &

# Workspace 4
alacritty --title "Clock" -e zsh -c "tty-clock -c -t -s -C 6 -B -f '%A, %d %B %Y'" &
alacritty --title "File Manager" -e zsh -c "ranger" &
alacritty --title "System Monitor" -e zsh -c "btm" &
alacritty --title "Mixer" -e zsh -c "pulsemixer" &

# Workspace 5
obsidian &

# Scratchpad
alacritty --title "Scratchpad" -e zsh -c "tmux new-session -s scratchpad 'neofetch; zsh'" &

# Give some time for applications to start
sleep 5

# Remove urgency hint from all windows in a loop
while i3-msg "[urgent=latest] focus"; do
    :
done

# Modify scratchpad title to avoid bugs
xdotool search --name "Scratchpad" set_window --name "Multiplexer"

# Move workspace programatically
i3-msg workspace 5
