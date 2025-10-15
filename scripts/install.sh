#!/bin/bash

# Repo directory location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Intro
echo "This script will set up your Debian environment."

# Ask for confirmation
read -p "Begin the installation? [Y/n]: " answer
if [ "${answer:0:1}" = "N" ] || [ "${answer:0:1}" = "n" ]; then
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
sudo apt update && sudo apt upgrade -y

# Enable contrib and non-free repositories
echo -e "\nEnabling contrib and non-free repositories..."
sudo sed -i 's/main$/main contrib non-free non-free-firmware/' /etc/apt/sources.list
sudo apt update

# Set desired packages
packages=(
    "xorg" "xinit" "x11-xserver-utils"                                      # X.Org
    "alacritty" "tmux" "zsh" "zsh-autosuggestions" "zsh-syntax-highlighting" # Terminal and shell
    "i3" "polybar" "dunst" "rofi" "picom" "lightdm" "feh"                   # WM environment
    "neofetch" "xsettingsd" "xcolor" "clipmenu" "flameshot" "qalculate-gtk" # Utilities
    "fonts-inter" "fonts-jetbrains-mono"                                    # Fonts
    "fonts-noto" "fonts-noto-cjk" "fonts-noto-color-emoji"                  # No-tofu fonts
    "pipewire" "pipewire-alsa" "pipewire-pulse" "pipewire-jack" "playerctl" # Audio
    "wireplumber"                                                           # PipeWire session manager
    "eza" "bat" "ripgrep" "zoxide" "fzf" "duf" "fd-find"                    # Commands
    "obsidian" "nemo"                                                       # Apps
    "curl" "wget" "git" "build-essential"                                   # Development tools
)

# Install packages
echo -e "\nThe following packages will be installed: ${packages[*]}"
read -p "Press Enter to continue..."
for package in "${packages[@]}"; do
    if ! dpkg -l | grep -q "^ii  $package"; then
        sudo apt install -y "$package"
    else
        echo "$package is already installed. Skipping..."
    fi
done

# Install packages that require manual installation
echo -e "\nInstalling additional packages..."

# Install i3lock-color (build from source)
if ! command -v i3lock &> /dev/null; then
    echo "Installing i3lock-color..."
    sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev \
        libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev \
        libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev \
        libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
    
    git clone https://github.com/Raymo111/i3lock-color.git /tmp/i3lock-color
    cd /tmp/i3lock-color
    ./install-i3lock-color.sh
    cd -
    rm -rf /tmp/i3lock-color
fi

# Install Oh My Posh
if ! command -v oh-my-posh &> /dev/null; then
    echo "Installing Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# Install Firefox ESR (if not already installed)
if ! command -v firefox &> /dev/null && ! command -v firefox-esr &> /dev/null; then
    echo "Installing Firefox..."
    sudo apt install -y firefox-esr
fi

# Install VS Code
if ! command -v code &> /dev/null; then
    echo "Installing Visual Studio Code..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update
    sudo apt install -y code
    rm /tmp/packages.microsoft.gpg
fi

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
wallpaper_dir="$HOME/Pictures/Wallpapers/"
echo -e "\nSetting up wallpapers..."
mkdir -p "$wallpaper_dir"
cp $REPO_ROOT/wallpapers/* "$wallpaper_dir"

# Enable services
echo -e "\nEnabling system services..."
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber
sudo systemctl enable lightdm.service

# Symlink config files
echo -e "\nLinking config files..."
"$REPO_ROOT/scripts/symlink.sh"

# Create XDG user directories
mkdir -p ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos

# Enable NTP to automatically sync time
sudo timedatectl set-ntp true

# Configure keyboard options
sudo localectl set-x11-keymap us,latam "" "" grp:rctrl_toggle,caps:swapescape,compose:ralt

# Set libqalculate commands
echo "set autocalc on" | qalc > /dev/null 2>&1
echo "set upxrates 7" | qalc > /dev/null 2>&1

# Install themes (optional)
echo -e "\nInstalling GTK themes and icons..."
mkdir -p ~/.themes ~/.icons

# Install Adwaita-based theme
if [ ! -d ~/.themes/adw-gtk3 ]; then
    git clone https://github.com/lassekongo83/adw-gtk3.git /tmp/adw-gtk3
    cp -r /tmp/adw-gtk3/themes/* ~/.themes/
    rm -rf /tmp/adw-gtk3
fi

# Install cursor theme
if [ ! -d ~/.icons/Quintom ]; then
    git clone https://github.com/RTWO/Quintom-Cursor-Linux.git /tmp/quintom
    cp -r /tmp/quintom/Quintom ~/.icons/
    rm -rf /tmp/quintom
fi

# Notify user for remaining changes
echo -e "\nInstallation completed. You'll need to manually: "
echo " - Set up specific app configurations via their respective GUIs"
echo " - Set up environment variables (for some status bar modules) in ~/.env"
echo " - Install necessary GPU drivers (AMD or Nvidia)"
echo " - Configure LightDM display manager settings if needed"
echo -e "\nNote: Run xrandr to see your monitor identifiers, then adjust necessary configs."

# Prompt for reboot
read -p "Do you want to reboot now? [Y/n]: " answer
if [ "${answer:0:1}" = "Y" ] || [ "${answer:0:1}" = "y" ] || [ -z "$answer" ]; then
    sudo reboot
else
    echo "You can manually reboot later to apply the remaining changes."
fi
