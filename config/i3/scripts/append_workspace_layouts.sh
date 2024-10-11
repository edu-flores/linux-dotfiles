#!/bin/bash

# Open layouts
for i in {1..4}; do
    i3-msg "workspace $i; append_layout ~/.config/i3/layouts/$i.json"
done

# Execute applications
alacritty --title "Scratchpad" -e zsh -c "tmux new-session -A -s scratchpad 'neofetch; zsh'" &
google-chrome-stable &
spotify &
code &
obsidian &

# Give some time for applications to start
sleep 5

# Remove urgency hint from all windows
while i3-msg "[urgent=latest] focus"; do
    :
done

# Modify scratchpad title to avoid conflicts with i3's config
xdotool search --name "Scratchpad" set_window --name "Multiplexer"

# Move workspace programatically
i3-msg workspace 5
