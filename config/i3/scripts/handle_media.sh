#!/bin/bash

if [[ $(ps -A | grep spotify) ]]; then
    playerctl -p spotify $1;
else
    playerctl -a $1;
fi
