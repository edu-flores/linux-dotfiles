#!/bin/bash

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
                                 - Eduardo Flores

This script will set up your Linux environment.
** IMPORTANT **: It should be run from the root directory of the cloned repo.
EOF

# Ask for confirmation
read -p "Begin the installation? [Y/n]: " answer
if [[ ! "$answer" =~ ^[Yy]$|^$ ]]; then
    echo "Exiting..."
    exit 0
fi

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
official_packages=("xorg-server" "xorg-xinit" "xorg-xrandr" "i3-wm" "alacritty" "dunst" "picom" "polybar" "rofi" "zsh" "ncspot" "xpad" "feh" "clipmenu" "ranger" "btm" "neofetch" "alsa-utils" "pulseaudio" "playerctl" "pulsemixer" "flameshot")
aur_packages=("google-chrome" "visual-studio-code-bin" "cava" "sptlrx-bin" "tty-clock")

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
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k
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
read -p "Start up the X server automatically when logging in? [Y/n]: " answer
if [[ "$answer" =~ ^[Yy]$|^$ ]]; then
    echo 'if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    startx
fi' > ~/.zprofile
fi

# Xinitrc
head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc
echo "exec i3" >> ~/.xinitrc
read -p "Which keyboard layout would you like to use? [US/latam]: " answer
if [[ "$answer" =~ ^(US|us|latam)$|^$ ]]; then
    echo "setxkbmap $answer" >> ~/.xinitrc
else
    echo "Layout not recognized. Skipping..."
fi

# Fonts and Wallpapers
font_dir="/usr/local/share/fonts/"
wallpaper_dir="$HOME/Pictures/Wallpapers/"

echo -e "\nSetting up fonts and wallpapers..."
sudo mkdir -p $font_dir
sudo cp $PWD/fonts/* $font_dir
mkdir -p $wallpaper_dir
cp $PWD/wallpapers/* $wallpaper_dir

# System bell
echo -e "\nDisabling system bell..."
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf > /dev/null

# Symlink config files
echo -e "\nLinking config files..."
rm -rf ~/.config/alacritty
rm -rf ~/.config/i3
rm -rf ~/.config/picom
rm -rf ~/.config/polybar
rm -rf ~/.config/rofi
rm -rf ~/.config/dunst
rm -f ~/.zshrc
ln -s $PWD/config/alacritty ~/.config/alacritty
ln -s $PWD/config/i3 ~/.config/i3
ln -s $PWD/config/picom ~/.config/picom
ln -s $PWD/config/polybar ~/.config/polybar
ln -s $PWD/config/rofi ~/.config/rofi
ln -s $PWD/config/dunst ~/.config/dunst
ln -s $PWD/config/zsh/.zshrc ~/.zshrc

# Notify user for remaining changes
echo -e "\nInstallation completed. You'll need to manually: "
echo " - Set up specific app configurations via their respective GUIs"
echo " - Set up WEATHER_API_KEY and WEATHER_LOCATION_ID in .env"
echo " - Set up the powerlevel10k theme"
echo " - Install necessary GPU drivers (AMD or Nvidia)"

# Prompt for reboot
read -p "Do you want to reboot now? [Y/n]: " answer
if [[ "$answer" =~ ^[Yy]$|^$ ]]; then
    sudo reboot
else
    echo "You can manually reboot later to apply the remaining changes."
fi
