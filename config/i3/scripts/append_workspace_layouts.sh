#!/bin/bash

# Debug
exec > /tmp/debug.log 2>&1
set -x

# Send notification
notify-send -i none "Please wait" "<i>Opening applications & setting up workspaces...</i>"

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

# Function to wait for a window with timeout and error handling
wait_for_window() {
    local window_class="$1"
    local window_id
    local elapsed=0
    local timeout=15

    echo "Waiting for window with class: $window_class"

    # Wait for the window to appear
    until window_id=$(xdotool search --class "$window_class" 2>/dev/null | head -n 1) && 
        xdotool getwindowgeometry "$window_id" 2>/dev/null; do
        ((elapsed++))
        echo "Retry $elapsed: $window_class not found yet..."
        sleep 1

        # Exit function if timeout occurs
        if [ "$elapsed" -ge "$timeout" ]; then
            echo "ERROR: Timeout waiting for $window_class"
            return 1
        fi
    done

    echo "SUCCESS: Found window with class: $window_class (Window ID: $window_id)"
}

# Move terminal to the scratchpad
echo "Waiting for Scratchpad terminal..."
wait_for_window "Alacritty"
i3-msg "[title=Scratchpad] move scratchpad, sticky enable, resize set 990 600"

# Wait for the rest of the windows to appear in parallel
echo "Waiting for Chrome..."
wait_for_window "Google-chrome" &
echo "Waiting for Spotify..."
wait_for_window "Spotify" &
echo "Waiting for VSCode..."
wait_for_window "Code" &
echo "Waiting for Obsidian..."
wait_for_window "obsidian" &

# Wait for all background processes to finish
wait

# Remove urgency hint from all windows
while i3-msg "[urgent=latest] focus"; do
    :
done

# Move workspace programmatically
i3-msg workspace 5
