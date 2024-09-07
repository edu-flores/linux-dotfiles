#!/bin/bash

# Repo directory location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Intro
cat << "EOF"
# ===============================================
#
#
#   ██████╗ ██╗ ██████╗██╗███╗   ██╗ ██████╗
#   ██╔══██╗██║██╔════╝██║████╗  ██║██╔════╝
#   ██████╔╝██║██║     ██║██╔██╗ ██║██║  ███╗
#   ██╔══██╗██║██║     ██║██║╚██╗██║██║   ██║
#   ██║  ██║██║╚██████╗██║██║ ╚████║╚██████╔╝
#   ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝╚═╝  ╚═══╝ ╚═════╝
#   ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗
#   ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝
#   ███████╗██║     ██████╔╝██║██████╔╝   ██║
#   ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║
#   ███████║╚██████╗██║  ██║██║██║        ██║
#   ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝
#
#
# ===============================================

This script will set up your Linux environment.
EOF

# Ask for confirmation
read -p "Begin the installation? [Y/n]: " answer
if [[ ! "$answer" =~ ^[Yy]$|^$ ]]; then
    echo "Exiting..."
    exit 0
fi

# Enter username full name
read -p "Enter your full name: " name
sudo chfn -f "$name" "$USER"

# Update the system & install packages
cat << "EOF"
   ___           __
  / _ \___ _____/ /_____ ____ ____ ___
 / ___/ _ `/ __/  '_/ _ `/ _ `/ -_|_-<
/_/   \_,_/\__/_/\_\\_,_/\_, /\__/___/
                        /___/

EOF

echo -e "\nUpdating the system..."
sudo pacman -Syu --noconfirm

# Set desired packages from the official and AUR repositories
official_packages=(
    "xorg-server" "xorg-xinit" "xorg-xrandr"
    "i3-wm" "tmux" "alacritty" "zsh" "dunst" "picom" "polybar" "rofi" "feh" "clipmenu" "ly"
    "ncspot" "ueberzug" "ranger" "btm" "neofetch" "flameshot" "obsidian"
    "noto-fonts" "noto-fonts-cjk" "noto-fonts-emoji" "noto-fonts-extras"
    "alsa-utils" "pulseaudio" "playerctl" "pulsemixer"
    "eza" "bat" "ripgrep" "zoxide" "fzf" "duf" "fd"
)
aur_packages=(
    "apple_cursor"
    "google-chrome" "visual-studio-code-bin"
    "sptlrx-bin" "cava" "tty-clock"
)

# Install packages from the official repositories
echo -e "\nThe following packages will be installed from the official repositories: ${official_packages[*]}"
read -p "Press Enter to continue..."
for package in "${official_packages[@]}"; do
    if ! pacman -Qi "$package" &> /dev/null; then
        sudo pacman -S --noconfirm "$package"
    else
        echo "$package is already installed. Skipping..."
    fi
done

# Install the AUR helper - yay
echo -e "\nInstalling AUR helper Yay..."
rm -rf ~/AUR
mkdir -p ~/AUR
git clone https://aur.archlinux.org/yay.git ~/AUR/yay

# Install packages from the AUR repositories
if (cd ~/AUR/yay && makepkg -si --noconfirm); then
    echo "The following packages will be installed from the AUR: ${aur_packages[*]}"
    read -p "Press Enter to continue..."
    for package in "${aur_packages[@]}"; do
        if ! yay -Qi "$package" &> /dev/null; then
            yay -S --noconfirm "$package"
        else
            echo "$package is already installed. Skipping..."
        fi
    done
else
    echo "Error: Yay installation failed. Skipping AUR packages..."
fi

# Shell - zsh
cat << "EOF"
   ______       ____
  / __/ /  ___ / / /
 _\ \/ _ \/ -_) / /
/___/_//_/\__/_/_/

EOF

echo -e "\nZ shell will be installed and configured with powerlevel10k, syntax highlighting and autosuggestions."
read -p "Press Enter to continue..."

rm -rf ~/.zsh
mkdir -p ~/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k ~/.zsh/powerlevel10k
chsh -s $(which zsh)

# Misc config
cat << "EOF"
  _____          ____
 / ___/__  ___  / _(_)__ _
/ /__/ _ \/ _ \/ _/ / _ `/
\___/\___/_//_/_//_/\_, /
                   /___/

EOF

# Empty .env file
echo -e "\nCreating an empty .env file..."
touch ~/.env

# Automatic startup
# read -p "Start up the X server automatically when logging in? [Y/n]: " answer
# if [[ "$answer" =~ ^[Yy]$|^$ ]]; then
#     echo 'if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
#     startx
# fi' > ~/.zprofile
# fi

# Xinitrc
# head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc
# echo "setxkbmap -option compose:ralt" >> ~/.xinitrc
# echo "exec i3" >> ~/.xinitrc

# Fonts and Wallpapers
font_dir="/usr/local/share/fonts/"
wallpaper_dir="~/Pictures/Wallpapers/"

echo -e "\nSetting up fonts and wallpapers..."
sudo mkdir -p $font_dir
sudo cp $REPO_ROOT/fonts/* $font_dir
mkdir -p $wallpaper_dir
cp $REPO_ROOT/wallpapers/* $wallpaper_dir

# System cursor
echo -e "\nSwitching cursor icons..."
echo -e "Xcursor.theme: macOS-White\nXcursor.size: 28" > ~/.Xresources

# System bell
echo -e "\nDisabling system bell..."
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf > /dev/null

# Symlink config files
echo -e "\nLinking config files..."
"$REPO_ROOT/scripts/symlink_config_files.sh"

# Configure ncspot
echo -e "\nConfiguring ncspot and lyrics..."
mkdir -p ~/.config/ncspot
echo -e "notify = true\nuse_nerdfont = true\nflip_status_indicators = true" > ~/.config/ncspot/config.toml
sed "s/player: .*/player: mpris/" ~/.config/sptlrx/config.yaml
sed "s/players: \[.*\]/players: [ncspot]/" ~/.config/sptlrx/config.yaml

# Enable the display manager service
echo -e "\nEnabling the display manager service..."
sudo systemctl enable ly.service

# Notify user for remaining changes
echo -e "\nInstallation completed. You'll need to manually: "
echo " - Set up specific app configurations via their respective GUIs"
echo " - Set up environment variables (for some status bar modules) in ~/.env"
echo " - Set up the powerlevel10k theme via its wizard (p10k configure)"
echo " - Install necessary GPU drivers (AMD or Nvidia)"

# Prompt for reboot
read -p "Do you want to reboot now? [Y/n]: " answer
if [[ "$answer" =~ ^[Yy]$|^$ ]]; then
    sudo reboot
else
    echo "You can manually reboot later to apply the remaining changes."
fi
