#!/bin/bash

# Send notification
notify-send -i none "Please wait" "<i>Opening applications & setting up workspaces...</i>"

# Open layouts
for i in {1..4}; do
    i3-msg "workspace $i; append_layout ~/.config/i3/layouts/$i.json"
done

# Execute applications
alacritty --class "Alacritty,Scratchpad" -e zsh -c "tmux new-session -A -s scratchpad 'neofetch; zsh'" &
dbus-launch nemo --name "Scratchpad" &
google-chrome-stable &
spotify &
code &
obsidian &

# Move workspace programmatically
i3-msg workspace 5
