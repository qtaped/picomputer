#!/bin/bash

# piComputer files installer
# https://github.com/qtaped

INSTALL_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
version=$(cat $INSTALL_DIR/version)

picomputersplash() {

clear
echo "       _ _____                   _           "
echo "   ___|_|     |___ _____ ___ _ _| |_ ___ ___ "
echo "  | . | |   --| . |     | . | | |  _| -_|  _|"
echo "  |  _|_|_____|___|_|_|_|  _|___|_| |___|_|  "
echo "  |_|                   |_|                  "
echo
echo "  piComputer $version                    [$chapitre/4]"
echo "  ..........................................."
echo "  $msg"
echo

}


installzsh() {

while true; do
   chapitre="2"
   picomputersplash
   read -p $'  Install and set zsh as default shell?\n\n→ Continue? [Y/n]' yn
   case $yn in

[Yy]* )
echo -e "\n:: Installing zsh and plugins...";
sudo apt install zsh zsh-autosuggestions zsh-syntax-highlighting

echo -e "\n:: Setting zsh as default shell...";
if [ -f $(which zsh) ]; then
chsh -s $(which zsh)
else
msg="Error: zsh was not found. Please try to reinstall it."
break
fi

msg="zsh installed and set as default shell.";
break;;

[Nn]* )
   msg=" "
   break;;

* )
   esac
done
}


installpkgs() {

while true; do
   chapitre="3"
   picomputersplash
   read -p $'  Install packages for piComputer?\n\n→ Continue? [Y/n]' yn
   case $yn in

[Yy]* )
echo -e "\n:: Running apt...";
sudo apt install vim xserver-xorg i3 polybar dunst rofi scrot feh xss-lock pulseaudio unclutter xdotool moc ranger tty-clock python3-pip
echo -e "\n:: Installing adafruit_ads1x15 for battery monitoring...";
sudo pip3 install adafruit_ads1x15
msg="Packages have been installed."
break;;

[Nn]* )
   msg=" "
   break;;

* )
   esac
done
}


setupdirs() {

echo -ne "\n:: Creating directories..."
mkdir -p $HOME/.config/polybar
mkdir -p $HOME/.config/i3
mkdir -p $HOME/.config/dunst
mkdir -p $HOME/.config/rofi
echo "  Done."

if [ -d "$HOME/.picomputer" ];
then
echo -e "\n:: piComputer configuration found. Remove? [Y/n]"
rm -rI $HOME/.picomputer
else
echo -e "\n:: No existing piComputer configuration found."
fi

echo -n "  Copying configuration files to $HOME/.picomputer"
mkdir -p $HOME/.picomputer
cp -r $INSTALL_DIR/config $HOME/.picomputer
cp -r $INSTALL_DIR/images $HOME/.picomputer
cp -r $INSTALL_DIR/scripts $HOME/.picomputer
echo "  [OK]"

echo -n "  chmod +x scripts"
chmod +x $HOME/.picomputer/scripts/*
echo "  [OK]"

}

linkconfigfiles() {

echo -e "\n:: Linking config files..."

while true; do
   read -p $'\n  Overwriting all configuration files?\n\n  \'Yes\' will overwrite all existing files without confirmation.\n  \'No\' will ask you before overwriting each file.\n\n[Y/n]? ' yn
   case $yn in

[Yy]* )
ln_opt="-sf"
break;;

[Nn]* )
ln_opt="-sfi"
break;;

* )
   esac
done

sudo ln $ln_opt $HOME/.picomputer/config/motd /etc/motd
ln $ln_opt $HOME/.picomputer/config/zshrc $HOME/.zshrc
ln $ln_opt $HOME/.picomputer/config/zshrc.local $HOME/.zshrc.local
ln $ln_opt $HOME/.picomputer/config/zprofile $HOME/.zprofile
ln $ln_opt $HOME/.picomputer/config/Xresources $HOME/.Xresources
ln $ln_opt $HOME/.picomputer/config/polybar $HOME/.config/polybar/config
ln $ln_opt $HOME/.picomputer/config/i3 $HOME/.config/i3/config
ln $ln_opt $HOME/.picomputer/config/dunstrc $HOME/.config/dunst/dunstrc
ln $ln_opt $HOME/.picomputer/config/rofi $HOME/.config/rofi/config.rasi
ln $ln_opt $HOME/.picomputer/config/picomputer.rasi $HOME/.config/rofi/picomputer.rasi
ln $ln_opt $HOME/.picomputer/config/vimrc $HOME/.vimrc
xrdb $HOME/.Xresources

}

installfonts() {

while true; do
   read -p $':: Install fonts for piComputer?\n\n→ Continue? [Y/n]' yn
   case $yn in

[Yy]* )
echo -e "\n:: Copying fonts to $HOME/.fonts...";
mkdir -p $HOME/.fonts
cp -r $INSTALL_DIR/fonts/JetBrainsMono $HOME/.fonts/
fc-list | grep JetBrains
echo -e "\n Fonts installed in $HOME/.fonts";
break;;

[Nn]* )
   break;;

* )
   esac
done
}

installconfig() {
while true; do
   chapitre="4"
   picomputersplash

   read -p $'  Install all config files for piComputer? \n\n  BECAREFUL: It will ask you if you want to remove configuration files.\n\n→ Continue? [Y/n]' yn
   case $yn in

[Yy]* )
echo -e "\n:: Running...";
setupdirs
linkconfigfiles
installfonts
echo -e "\n:: Installation complete. Do you want to remove installation folder? [Y/n]"
sudo rm -rI $INSTALL_DIR
echo -e "\n\n:: Done. All configuration files are here: $HOME/.picomputer"
echo -e "\n  enjoy!\n"
exit;;

[Nn]* )
   msg=" "
   break;;
* )
   esac
done

}


## Welcome

while true; do
   chapitre="1"
   picomputersplash
   read -p $'  Welcome.\n\n→ Continue? [Y/n]' yn

   case $yn in
[Yy]* )
msg=" "
installzsh
installpkgs
installconfig;;

[NnQq]* )
echo -e "\n  :(\n"
exit;;
* )
msg="Enter (y)es or (n)o.";;
   esac
done
