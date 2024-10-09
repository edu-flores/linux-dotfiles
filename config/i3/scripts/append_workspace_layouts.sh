#!/bin/bash

# Open layouts
for i in {1..4}; do
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
obsidian &

# Scratchpad
alacritty --title "Scratchpad" -e zsh -c "tmux new-session -A -s scratchpad 'neofetch; zsh'" &

# Give some time for applications to start
sleep 5

# Remove urgency hint from all windows in a loop
while i3-msg "[urgent=latest] focus"; do
    :
done

# Modify scratchpad title to avoid conflicts with i3's config
xdotool search --name "Scratchpad" set_window --name "Multiplexer"

# Move workspace programatically
i3-msg workspace 5
