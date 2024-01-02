#!/bin/bash

# Intro
cat << "EOF"
   ___  _     _              ____        _      __
  / _ \(_)___(_)__  ___ _   / __/_______(_)__  / /_
 / , _/ / __/ / _ \/ _ `/  _\ \/ __/ __/ / _ \/ __/
/_/|_/_/\__/_/_//_/\_, /  /___/\__/_/ /_/ .__/\__/
                  /___/                /_/

This script will set up your Linux environment.
Your answers are case sensitive.
** Note: It should be run from the root directory of the cloned repository **
EOF

# Ask for confirmation
read -p "Begin the installation? [Y/n]: " answer
if [ "$answer" != "Y" ]; then
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
official_packages=("xorg-server" "xorg-xinit" "xorg-xrandr" "i3-wm" "alacritty" "dunst" "picom" "polybar" "rofi" "zsh" "xpad" "feh" "clipmenu" "ranger" "btop" "neofetch" "alsa-utils" "pulseaudio" "playerctl" "flameshot")
aur_packages=("google-chrome" "visual-studio-code-bin" "spotify" "cmatrix-git" "pipes.sh" "tty-clock")

# Install packages from the official repositories
echo -e "\nThe following packages will be installed from the official repositories: ${official_packages[*]}"
echo "Press Enter to continue..."
read -r
for package in "${official_packages[@]}"; do
    if ! pacman -Qi "$package" &> /dev/null; then
        sudo pacman -S --noconfirm "$package"
    else
        echo "$package is already installed. Skipping..."
    fi
done

# Install the AUR helper - yay
echo -e "\nInstalling AUR helper Yay..."
rm -rf ~/AUR 2> /dev/null
mkdir -p ~/AUR
git clone https://aur.archlinux.org/yay.git ~/AUR/yay

# Check if yay installation is successful
if ! ~/AUR/yay/makepkg -si; then
    echo "Error: Yay installation failed. Skipping AUR packages..."
else
    # Install packages from the AUR repositories
    echo "The following packages will be installed from the AUR: ${aur_packages[*]}"
    echo "Press Enter to continue..."
    read -r
    for package in "${aur_packages[@]}"; do
        if ! yay -Qi "$package" &> /dev/null; then
            yay -S --noconfirm "$package"
        else
            echo "$package is already installed. Skipping..."
        fi
    done
fi

# Shell - zsh
cat << "EOF"
   ______       ____
  / __/ /  ___ / / /
 _\ \/ _ \/ -_) / /
/___/_//_/\__/_/_/

EOF

echo -e "\nZsh will be installed and configured with powerlevel10k, syntax highlighting and autosuggestions."
echo "Press Enter to continue..."
read -r
rm -rf ~/.zsh 2> /dev/null
mkdir -p ~/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k
sudo chsh -s $(which zsh)

# Misc config
cat << "EOF"
  _____          ____
 / ___/__  ___  / _(_)__ _
/ /__/ _ \/ _ \/ _/ / _ `/
\___/\___/_//_/_//_/\_, /
                   /___/

EOF

# Profile configurations
sudo head -n -5 /etc/X11/xinit/xinitrc > /etc/X11/xinit/xinitrc
echo "exec i3" | sudo tee -a /etc/X11/xinit/xinitrc

read -p "Start up the X server automatically when logging in? [Y/n]: " answer
if [ "$answer" == "Y" ]; then
    echo 'if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    startx
fi' > ~/.zprofile
fi
read -p "Which keyboard layout would you like to use? (e.g. latam, us, etc): " layout
echo "setxkbmap $layout" > ~/.xprofile

# Weather module
rm ~/.env 2> /dev/null
read -p "Would you like to set up the weather module? [Y/n]: " answer
if [ "$answer" == "Y" ]; then
    read -p "Enter your OpenWeatherMap API key: " api_key
    read -p "Enter your location ID: " location_id
    echo "export API_KEY=$api_key" >> ~/.env
    echo "export LOCATION_ID=$location_id" >> ~/.env
fi

# Fonts and Wallpapers
font_dir="/usr/local/share/fonts/"
wallpaper_dir="$HOME/Pictures/Wallpapers/"

echo -e "\nSetting up fonts and wallpapers..."
mkdir -p $font_dir 2> /dev/null
sudo cp $PWD/fonts/* $font_dir
mkdir -p $wallpaper_dir 2> /dev/null
cp $PWD/wallpapers/* $wallpaper_dir

# System bell
echo -e "\nDisabling system bell..."
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

# Symlink config files
echo -e "\nLinking config files..."
./$PWD/scripts/link_files.sh 2> /dev/null

# Notify user for pending changes
echo -e "\nInstallation completed. You will need to manually: "
echo " - Set up specific app configurations via their respective GUIs"
echo " - Install necessary GPU drivers"

# Prompt for reboot
read -p "Do you want to reboot now? [Y/n]: " answer
if [ "$answer" == "Y" ]; then
    sudo reboot
else
    echo "You can manually reboot later to apply the remaining changes."
fi
