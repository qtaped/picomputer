#!/bin/bash

# piComputer files installer
# v0.5.1
# 2022-05-07
# https://github.com/qtaped

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
version=$(cat $SCRIPT_DIR/version)

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
sudo apt install vim i3 polybar dunst rofi scrot feh xss-lock pulseaudio unclutter xdotool moc ranger tty-clock
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

echo -n "  Removing $SCRIPT_DIR/.git"
sudo rm -r $SCRIPT_DIR/.git
echo "  ..........Ok"
echo -n "  Moving configuration files to $HOME/.picomputer"
mv $SCRIPT_DIR $HOME/.picomputer
echo "  ..........Ok"

echo -n "  chmod +x scripts"
chmod +x $HOME/.picomputer/scripts/*
echo "  ..........Ok"

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
ln $ln_opt $HOME/.picomputer/config/qtheme.rasi $HOME/.config/rofi/qtheme.rasi
ln $ln_opt $HOME/.picomputer/config/vimrc $HOME/.vimrc

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
rm $HOME/.picomputer/install.sh
echo -e "\n\n:: Done. All configuration files are here: $HOME/.picomputer";
echo
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

installzsh
installpkgs
installconfig;;

[NnQq]* )
echo -e "\n  :(\n"
exit;;
* )
msg="Enter (y)es or (n)o";;
   esac
done
