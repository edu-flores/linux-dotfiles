#!/bin/bash

# Remove symlinks
remove() {
	rm -rf ~/.config/alacritty
	rm -rf ~/.config/i3
	rm -rf ~/.config/picom
	rm -rf ~/.config/polybar
	rm -rf ~/.config/rofi
	rm -rf ~/.config/dunst
	rm -f ~/.zshrc
}

# Set up symlinks
symlink() {
	ln -s $PWD/config/alacritty ~/.config/alacritty
	ln -s $PWD/config/i3 ~/.config/i3
	ln -s $PWD/config/picom ~/.config/picom
	ln -s $PWD/config/polybar ~/.config/polybar
	ln -s $PWD/config/rofi ~/.config/rofi
	ln -s $PWD/config/dunst ~/.config/dunst
	ln -s $PWD/config/zsh/.zshrc ~/.zshrc
}

### IMPORTANT: THIS SCRIPT SHOULD BE RUN FROM THE REPO ROOT ###
remove
symlink
