#!/bin/bash

# Repo directory location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Remove symlinks
remove() {
    rm -rf ~/Documents/Vault/.obsidian
    rm -rf ~/.config/alacritty
    rm -rf ~/.config/dunst
    rm -rf ~/.config/i3
    rm -rf ~/.config/neofetch
    rm -rf ~/.config/picom
    rm -rf ~/.config/polybar
    rm -rf ~/.config/rofi
    rm -rf ~/.config/tmux
    rm -f ~/.zshrc
}

# Set up symlinks
symlink() {
    mkdir -p ~/Documents/Vault/.obsidian
    cp -r "$REPO_ROOT/config/obsidian/"* ~/Documents/Vault/.obsidian
    ln -s "$REPO_ROOT/config/alacritty" ~/.config/alacritty
    ln -s "$REPO_ROOT/config/dunst" ~/.config/dunst
    ln -s "$REPO_ROOT/config/i3" ~/.config/i3
    ln -s "$REPO_ROOT/config/neofetch" ~/.config/neofetch
    ln -s "$REPO_ROOT/config/picom" ~/.config/picom
    ln -s "$REPO_ROOT/config/polybar" ~/.config/polybar
    ln -s "$REPO_ROOT/config/rofi" ~/.config/rofi
    ln -s "$REPO_ROOT/config/tmux" ~/.config/tmux
    ln -s "$REPO_ROOT/config/zsh/.zshrc" ~/.zshrc
}

remove
symlink
