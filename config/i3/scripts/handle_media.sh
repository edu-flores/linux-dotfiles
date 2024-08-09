#!/bin/bash

if [[ $(ps -A | grep ncspot) ]]; then
    playerctl -p ncspot $1;
else
    playerctl -a $1;
fi
