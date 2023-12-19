#!/bin/bash

# Remove symlinks
remove() {
	rm -rf ~/.config/alacritty
	rm -rf ~/.config/i3
	rm -rf ~/.config/picom
	rm -rf ~/.config/polybar
	rm -rf ~/.config/rofi
	rm ~/.zshrc
}

# Set up symlinks
symlink() {
	ln -s $HOME/Documents/GitHub/linux-dotfiles/config/alacritty ~/.config/alacritty
	ln -s $HOME/Documents/GitHub/linux-dotfiles/config/i3 ~/.config/i3
	ln -s $HOME/Documents/GitHub/linux-dotfiles/config/picom ~/.config/picom
	ln -s $HOME/Documents/GitHub/linux-dotfiles/config/polybar ~/.config/polybar
	ln -s $HOME/Documents/GitHub/linux-dotfiles/config/rofi ~/.config/rofi
	ln -s $HOME/Documents/GitHub/linux-dotfiles/config/zsh/.zshrc ~/.zshrc
}

remove
symlink
