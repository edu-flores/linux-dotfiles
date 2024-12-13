#!/bin/bash

# Repo directory location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Intro
echo "This script will set up your Linux environment."

# Ask for confirmation
read -p "Begin the installation? [Y/n]: " answer
if [ "${answer:0:1}" = "Y" ] || [ "${answer:0:1}" = "y" ] || [ -z "$answer" ]; then
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

# Customize package manager
sudo sed -i "s/^#Color/Color/" /etc/pacman.conf
sudo sed -i "s/^#ParallelDownloads = 5/ParallelDownloads = 5/" /etc/pacman.conf
sudo sed -i "s/^#VerbosePkgLists/VerbosePkgLists/" /etc/pacman.conf

# Set desired packages from the official and AUR repositories
official_packages=(
    "xorg-server" "xorg-xinit" "xorg-xrandr"  # Xorg
    "alacritty" "tmux" "zsh" "zsh-autosuggestions" "zsh-syntax-highlighting"  # Terminal & shell
    "i3-wm" "polybar" "dunst" "rofi" "picom"  "ly" "feh"  # Window manager environment
    "neofetch" "flameshot" "xsettingsd" "xcolor" "clipmenu" "obsidian" "nemo"  # Utils
    "inter-font" "ttf-jetbrains-mono-nerd"  # Main UI and editor fonts
    "noto-fonts" "noto-fonts-cjk" "noto-fonts-emoji" "noto-fonts-extras"  # No tofu fonts
    "pipewire" "pipewire-alsa" "pipewire-pulse" "pipewire-jack" "playerctl"  # Audio
    "eza" "bat" "ripgrep" "zoxide" "fzf" "duf" "fd" "less"  # Commands
)
aur_packages=(
    "oh-my-posh" "quintom-cursor-theme-git" "adw-gtk-theme-git" "morewaita-icon-theme-git"  # Styling
    "google-chrome" "spotify" "visual-studio-code-bin"  # Apps
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

# Create XDG user directories
mkdir -p ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos

# Enable NTP to automatically sync time
sudo timedatectl set-ntp true

# Configure keyboard options
sudo localectl set-x11-keymap us,latam "" "" grp:rctrl_toggle,caps:swapescape,compose:ralt

# Notify user for remaining changes
echo -e "\nInstallation completed. You'll need to manually: "
echo " - Set up specific app configurations via their respective GUIs"
echo " - Set up environment variables (for some status bar modules) in ~/.env"
echo " - Install necessary GPU drivers (AMD or Nvidia)"
echo -e "\nNote: Run xrandr to see your monitor identifiers, then adjust necessary configs."

# Prompt for reboot
read -p "Do you want to reboot now? [Y/n]: " answer
if [ "${answer:0:1}" = "Y" ] || [ "${answer:0:1}" = "y" ] || [ -z "$answer" ]; then
    sudo reboot
else
    echo "You can manually reboot later to apply the remaining changes."
fi
