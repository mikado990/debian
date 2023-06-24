#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Making .config and Moving config files and background to Pictures
#cd $builddir
#mkdir -p /home/$username/.config
#mkdir -p /home/$username/Pictures
#mkdir -p /home/$username/Pictures/backgrounds
#cp -R dotconfig/* /home/$username/.config/
#mv user-dirs.dirs /home/$username/.config
#chown -R $username:$username /home/$username

# Installing Essential Programs 
apt install feh kitty rofi picom lxpolkit x11-xserver-utils unzip pulseaudio pavucontrol build-essential -y
# Installing Other less important Programs
apt install psmisc vim lxappearance lightdm -y

# Enable graphical login and change target from CLI to GUI
systemctl enable lightdm
systemctl set-default graphical.target

