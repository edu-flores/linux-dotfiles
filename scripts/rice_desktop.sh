#!/bin/bash

# Intro
cat << "EOF"
# ················································
# : ██████╗ ██╗ ██████╗██╗███╗   ██╗ ██████╗     :
# : ██╔══██╗██║██╔════╝██║████╗  ██║██╔════╝     :
# : ██████╔╝██║██║     ██║██╔██╗ ██║██║  ███╗    :
# : ██╔══██╗██║██║     ██║██║╚██╗██║██║   ██║    :
# : ██║  ██║██║╚██████╗██║██║ ╚████║╚██████╔╝    :
# : ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝╚═╝  ╚═══╝ ╚═════╝     :
# : ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗ :
# : ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝ :
# : ███████╗██║     ██████╔╝██║██████╔╝   ██║    :
# : ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║    :
# : ███████║╚██████╗██║  ██║██║██║        ██║    :
# : ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝    :
# ················································
                                 - Eduardo Flores

This script will set up your Linux environment.
** IMPORTANT **: It should be run from the root directory of the cloned repo.
EOF

# Ask for confirmation
read -p "Begin the installation? [Y/n]: " answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
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
rm -rf ~/AUR
mkdir -p ~/AUR
git clone https://aur.archlinux.org/yay.git ~/AUR/yay

# Install packages from the AUR repositories
if (cd ~/AUR/yay && makepkg -si ); then
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

echo -e "\nZsh will be installed and configured with powerlevel10k, syntax highlighting and autosuggestions."
echo "Press Enter to continue..."
read -r
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

# X configurations
read -p "Start up the X server automatically when logging in? [Y/n]: " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo 'if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    startx
fi' > ~/.zprofile
fi
read -p "Which keyboard layout would you like to use? (e.g. latam, us, etc): " layout
echo "setxkbmap $layout" > ~/.xinitrc
echo "exec i3" >> ~/.xinitrc

# Weather module
echo -n > ~/.env
read -p "Would you like to set up the weather module? [Y/n]: " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    read -p "Enter your OpenWeatherMap API key: " api_key
    read -p "Enter your location ID: " location_id
    echo "export API_KEY=$api_key" >> ~/.env
    echo "export LOCATION_ID=$location_id" >> ~/.env
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
echo -e "\nInstallation completed. You will need to manually: "
echo " - Set up specific app configurations via their respective GUIs"
echo " - Set up the powerlevel10k theme as you wish"
echo " - Install necessary GPU drivers (AMD or Nvidia)"

# Prompt for reboot
read -p "Do you want to reboot now? [Y/n]: " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    sudo reboot
else
    echo "You can manually reboot later to apply the remaining changes."
fi
