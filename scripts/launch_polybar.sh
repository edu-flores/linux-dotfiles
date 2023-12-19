#!/bin/bash

# Terminate already running bar instances
pkill polybar

# Launch
polybar top &
