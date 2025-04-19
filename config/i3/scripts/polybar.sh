#!/bin/bash

# Terminate instance
killall polybar

# Launch instance
polybar -c ~/.config/polybar/polybar.ini main &
