#!/bin/bash

# piComputer config files installer
# v0.4
# 2022-05-05
# https://github.com/qtaped

picomputerlogo() {

echo "       _ _____                   _           "
echo "   ___|_|     |___ _____ ___ _ _| |_ ___ ___ "
echo "  | . | |   --| . |     | . | | |  _| -_|  _|"
echo "  |  _|_|_____|___|_|_|_|  _|___|_| |___|_|  "
echo "  |_|                   |_|                  "
echo ""
echo "  piComputer installer v0.4"
echo "  ........................."
echo ""

}

installpkgs() {

sudo apt install vim i3 polybar dunst rofi scrot feh xss-lock pulseaudio unclutter xdotool moc ranger

}

installzsh() {

while true; do
   read -p $'  Install and set zsh as default shell? [Y/n]' yn
   case $yn in

[Yy]* ) 
echo ":: Installing zsh and plugins...";
sudo apt install zsh zsh-autosuggestions zsh-syntax-highlighting

echo ":: Setting zsh as default shell...";
if [ -f $(which zsh) ];
then
chsh -s $(which zsh)
else
echo "Error: zsh was not found. Please try to reinstall it."
break
fi

echo "zsh installed and set as default shell.";
installpkgs
break;;

[Nn]* ) 
   installpkgs
   break;;

* )
   echo "Please answer the question. [Y/n]";;
   esac
done
}

mkalldirs() {

echo ":: Creating directories..."
mkdir $HOME/.config/polybar
mkdir $HOME/.config/i3
mkdir $HOME/.config/dunst
mkdir $HOME/.config/rofi
echo "  Done."

if [ -d "$HOME/.picomputer" ];
then
echo ":: piComputer configuration found. Remove? [Y/n]"
rm -rI $HOME/.picomputer
else
echo ":: No existing piComputer configuration found."
fi

echo "  Moving configuration files to $HOME/.picomputer"

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
mv $SCRIPT_DIR $HOME/.picomputer
chmod +x $HOME/.picomputer/scripts/*

}

linkconfigfiles() {
echo ":: Linking config files..."
ln -sfi $HOME/.picomputer/config/zshrc $HOME/.zshrc
ln -sfi $HOME/.picomputer/config/zshrc.local $HOME/.zshrc.local
ln -sfi $HOME/.picomputer/config/zprofile $HOME/.zprofile
ln -sfi $HOME/.picomputer/config/polybar $HOME/.config/polybar/config
ln -sfi $HOME/.picomputer/config/i3 $HOME/.config/i3/config
ln -sfi $HOME/.picomputer/config/dunstrc $HOME/.config/dunst/dunstrc
ln -sfi $HOME/.picomputer/config/rofi $HOME/.config/rofi/config.rasi
ln -sfi $HOME/.picomputer/config/qtheme.rasi $HOME/.config/rofi/qtheme.rasi
ln -sfi $HOME/.picomputer/config/vimrc $HOME/.vimrc

echo "  Done."

}

installconfig() {
while true; do
   clear
   picomputerlogo

   read -p $'  Install all config files for piComputer? \n\n  WARNING: All your existing config files will be remove.\n\n→ Continue? [Y/n]' yn
   case $yn in

[Yy]* ) 
echo ":: Running...";
mkalldirs
linkconfigfiles
rm $HOME/.picomputer/install.sh
echo "  All configuration files are here: $HOME/.picomputer";
echo "  All done.";
break;;

[Nn]* ) 
   echo "";
   echo "  Quit."; exit;;

* )
   echo "  Please answer the question. [Y/n]";;
   esac
done
}


while true; do
   clear
   picomputerlogo
   read -p $'  Install packages for piComputer?\n\n→ Continue? [Y/n]' yn

   case $yn in
[Yy]* ) 

echo ":: Running...";
installzsh
installconfig
break;;

[Nn]* ) 
installconfig
break;;
* )
   echo "  Please answer the question. [Y/n]";;
   esac
done
