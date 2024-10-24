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

# Enable packet manager colors
sudo sed -i "s/^#Color/Color/" /etc/pacman.conf

# Set desired packages from the official and AUR repositories
official_packages=(
    "xorg-server" "xorg-xinit" "xorg-xrandr"
    "alacritty" "tmux" "zsh" "zsh-autosuggestions" "zsh-syntax-highlighting"
    "i3-wm" "dunst" "picom" "polybar" "rofi" "feh" "xcolor" "clipmenu" "ly" "neofetch" "flameshot" "obsidian"
    "ttf-jetbrains-mono-nerd" "noto-fonts" "noto-fonts-cjk" "noto-fonts-emoji" "noto-fonts-extras"
    "pipewire" "pipewire-alsa" "pipewire-pulse" "pipewire-jack" "playerctl"
    "eza" "bat" "ripgrep" "zoxide" "fzf" "duf" "fd" "less"
)
aur_packages=(
    "apple_cursor" "oh-my-posh"
    "google-chrome" "spotify" "visual-studio-code-bin"
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

# Install the AUR helper
echo -e "\nChecking for AUR helper (paru)..."
if ! command -v paru &> /dev/null; then
    echo "Paru is not installed. Installing..."
    rm -rf ~/AUR
    mkdir -p ~/AUR
    git clone https://aur.archlinux.org/paru.git ~/AUR/paru
    if (cd ~/AUR/paru && makepkg -si --noconfirm); then
        echo "Paru installed successfully."
    else
        echo "Error: Paru installation failed. Exiting..."
        rm -rf ~/AUR
        exit 1
    fi
else
    echo "Paru is already installed. Skipping installation..."
fi

# Install packages from the AUR repositories
echo "The following packages will be installed from the AUR: ${aur_packages[*]}"
for package in "${aur_packages[@]}"; do
    if ! paru -Qi "$package" &> /dev/null; then
        paru -S --noconfirm "$package"
    else
        echo "$package is already installed. Skipping..."
    fi
done

# Clean up AUR build directory
echo "Cleaning up..."
rm -rf ~/AUR

# Misc config
cat << "EOF"
  _____          ____
 / ___/__  ___  / _(_)__ _
/ /__/ _ \/ _ \/ _/ / _ `/
\___/\___/_//_/_//_/\_, /
                   /___/

EOF

# Change user shell to zsh
echo -e "\nSetting up shell..."
chsh -s $(which zsh)

# Environment variables file
echo -e "\nCreating a .env file..."
cp $REPO_ROOT/.env.example ~/.env.test

# Wallpapers
wallpaper_dir="~/Pictures/Wallpapers/"
echo -e "\nSetting up wallpapers..."
mkdir -p $wallpaper_dir
cp $REPO_ROOT/wallpapers/* $wallpaper_dir

# Enable services
echo -e "\nEnabling system services..."
systemctl --user enable pipewire pipewire-pulse
systemctl --user start pipewire pipewire-pulse
sudo systemctl enable ly.service

# Symlink config files
echo -e "\nLinking config files..."
"$REPO_ROOT/scripts/symlink_config_files.sh"

# Send configuration files to their appropriate directory
echo -e "\nCopying miscellaneous configuration files..."
for file in "$REPO_ROOT/misc/"*; do
  location=$(head -n 1 "$file" | sed "s/^# *//")
  mkdir -p "$location"
  sed "1d" "$file" > "$location/$(basename "$file")"
done

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
