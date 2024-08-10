#!/bin/bash

if ps -A | grep -q ncspot; then
    playerctl -p ncspot $1;
else
    playerctl -a $1;
fi
