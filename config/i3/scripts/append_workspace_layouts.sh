#!/bin/bash

# Open layouts
for i in {1..4}; do
    i3-msg "workspace $i; append_layout ~/.config/i3/layouts/$i.json"
done

# Open scratchpad applications
alacritty -e zsh -c "tmux new-session -A -s scratchpad 'neofetch; zsh'" &
nemo &

# Send them to the scratchpad
sleep 3
i3-msg "[class=Alacritty] floating enable, sticky enable, mark multiplexer, move scratchpad"
i3-msg "[class=Nemo] floating enable, sticky enable, mark file_manager, move scratchpad"

# Open the rest of the applications
google-chrome-stable &
spotify &
code &
obsidian &

# Move workspace programmatically
i3-msg workspace 5

# Send notification
dunstify -i process-working-symbolic "Please wait" "<i>Opening applications & setting up workspaces...</i>"
