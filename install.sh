#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(/home/$username)

# Clone repo with firefox user.js file
git clone https://codeberg.org/Narsil/user.js/src/branch/main/desktop

# Update packages list and update system
apt update
apt upgrade -y

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.cache
mkdir -p /home/$username/.config
mkdir -p /home/$username/.local
mkdir -p /home/$username/.local/src
mkdir -p /home/$username/Pictures
mkdir -p /home/$username/Downloads
mkdir -p /home/$username/Videos
mkdir -p /home/$username/Pictures/backgrounds
cp bg.jpg /home/$username/Pictures/backgrounds/
#cp -R dotconfig/* /home/$username/.config/
#mv user-dirs.dirs /home/$username/.config
chown -R $username:$username /home/$username

# Build dependencies for DWM and onther
apt install build-essential libx11-dev libxft-dev libxinerama-dev -y

# Installing Essential Programs 
apt install neovim dmenu dunst feh x11-xserver-utils wget unzip -y

# Installing Other less important Programs
apt install firefox-esr lightdm mpv newsboat -y

# Clone DWM and install
cd /home/$username/.local/src
git clone https://git.suckless.org/dwm
cd /home/$username/.local/src/dwm
make install

# Clone ST and install
cd /home/$username/.local/src
git clone https://git.suckless.org/st
cd /home/$username/.local/src/st
make install

# Add DWM xsession
cd $builddir/debian
cp dwm.desktop /usr/share/xsessions/

# Fix long shutdowns
sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf

# Set LightDM to auto start DWM
sed -i 's/#autologin-user=.*/autologin-user=$username/' /etc/lightdm/lightdm.conf
sed -i 's/#user-session=.*/user-session=dwm/' /etc/lightdm/lightdm.conf

# Enable graphical login and change target from CLI to GUI
#systemctl enable lightdm
#systemctl set-default graphical.target
