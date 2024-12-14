#!/bin/bash

# TODO: Make this way more robust

# Read the input expression from Rofi
expr="$1"

# Use Python to evaluate the expression
result=$(python3 -c "print(eval('$expr'))")

# Output the result to Rofi
echo "$result"
