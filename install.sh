#!/bin/bash

# piComputer files installer
# https://github.com/qtaped

piComputerSplash() {

clear
echo -e "\033[38;5;3m\n\
       _ _____                   _            \n\
   ___|_|     |___ _____ ___ _ _| |_ ___ ___  \n\
  | . | |   --| . |     | . | | |  _| -_|  _| \n\
  |  _|_|_____|___|_|_|_|  _|___|_| |___|_|   \n\
  |_|                   |_|                   \n\n\
  $topLeftTitle\n\033[0m"

if [ -f $installerLog ]; then
echo "  Logs available: $installerLog"
echo
fi
echo "  Press any key to continue or 'q' to quit."
read -sn 1 -r
if [[ $REPLY =~ ^[Qq]$ ]]; then
    echo
    echo "  bye!"
    echo
    exit 1
fi
}

# installer options
installerDir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
installerLog="$installerDir/piComputer_installer.log"
tmpLog="/tmp/piComputer_tmp"
version=$(cat $installerDir/version)
installPath="$HOME/.picomputer"

# whiptail options
topLeftTitle="piComputer installer $version"
menuHeight=14
width=84
defaultTitle="piComputer"
defaultMenu="default"
defaultColor="brown"

piComputerSplash

#change colors of whiptail
wtColors() {
  local color="$1"
  local bgcolor="black"
  local new_colors="
  root=$color,$bgcolor
  window=$color,$bgcolor
  border=$color,$bgcolor
  shadow=$color,$bgcolor
  button=$bgcolor,$color
  actbutton=$bgcolor,$color
  compactbutton=$color,$bgcolor
  title=$color,$bgcolor
  roottext=$color,$bgcolor
  textbox=$color,$bgcolor
  acttextbox=$color,$bgcolor
  entry=$color,$bgcolor
  disentry=$color,$bgcolor
  checkbox=$color,$bgcolor
  actcheckbox=$bgcolor,$color
  emptyscale=$color,$bgcolor
  fullscale=$bgcolor,$color
  listbox=$color,$bgcolor
  actlistbox=$color,$bgcolor
  actsellistbox=$bgcolor,$color
"
export NEWT_COLORS="$new_colors"
}

# Simple function using whiptail to display messages
wtMsg() {
local title="$1"
local message="$2"
local type="$3"

case "$type" in
    msgbox)
        height=10
        ;;
    gauge)
        height=8
        local progress="$4"
        whiptail --backtitle="$topLeftTitle" --title "$title" --gauge "$message" $height $width $progress
        return
        ;;
    *)
        height=8
        ;;
esac

whiptail --backtitle="$topLeftTitle" --title "$title" --"$type" "$message" $height $width
}

# Start installer logs
rm -f $tmpLog
if [ -f $installerLog ]; then
  wtColors lightgray
  if wtMsg "piComputer installer" "A previous piComputer installer log has been found ($installerLog). Do you want to remove it?" "yesno"; then
    rm -f $installerLog 
  fi
fi
echo -e "$(date) -- $topLeftTitle\n\
$installerLog\\n\n" >> $installerLog

clear


# Functions



function installPackages() {

# Use apt-get to update and install the selected packages
if wtMsg "Package Updater" "Would you like to update your package database and upgrade your system?" "yesno"; then
  # Use apt-get to update the package database
  wtMsg "$defaultTitle" "Updating package database... Please wait." "infobox"
  echo "## Update packages" >> $installerLog
  sudo apt-get update && sudo apt-get upgrade 2>&1 | tee $tmpLog | tee -a $installerLog 
  # Check if there were any errors during the update
  if grep -q "E:" $tmpLog 2>&1; then
    wtColors red
    wtMsg "Package Updater" "Error updating package database. Please check the output file $installerLog for details." "msgbox"
    wtColors $defaultColor
    rm $tmpLog
  else
    wtColors green
    wtMsg "Package Updater" "Package database successfully updated." "msgbox"
    echo "Package database successfully updated." >> $installerLog
    wtColors $defaultColor
  fi
fi


packages=$(whiptail --backtitle="$topLeftTitle" --title "Package Installation"  --ok-button "Install"  --checklist \
    "Select packages to install. Packages selected by default are needed." $menuHeight $width 7 \
    "vim" "programmer's text editor" ON \
    "xserver-xorg" "X Window System display server" ON \
    "x11-xserver-utils" "utilities for xserver" ON \
    "xinit" "X Window System initializer" ON \
    "xdotool" "command-line X11 automation tool" ON \
    "zsh" "Z shell" ON \
    "zsh-autosuggestions" "autosuggestions for zsh" ON \
    "zsh-syntax-highlighting" "syntax color highlighting for zsh" ON \
    "xclip" "clipboard" ON \
    "xss-lock" "use external locker as X screen saver" ON \
    "python3-pip" "package manager for Python packages" ON \
    "rxvt-unicode" "terminal emulator" ON \
    "i3" "tiling window manager" ON \
    "polybar" "status bars" ON \
    "dunst" "lightweight notification-daemon" ON \
    "rofi" "window switcher, run launcher" ON \
    "ranger" "console file manager" ON \
    "scrot" "screen capture utility" ON \
    "feh" "image viewer" ON \
    "pulseaudio" "sound server system" ON \
    "pulseaudio-module-bluetooth" "enables audio bluetooth devices" OFF \
    "moc" "console audio player" OFF \
    "cava" "console audio visualizer" OFF \
    "qalc" "console calculator" OFF \
    "lynx" "console browser" OFF \
    "tty-clock" "console digital clock" OFF \
    "cmatrix" "scrolling Matrix like screen" OFF \
    "mpv" "light media player" OFF \
    "moon-buggy" "console game, a buggy on the moon" OFF \
    3>&1 1>&2 2>&3)

fail=false
i=0
progress=0
num_packages=$(echo $packages | wc -w)

echo "## installPackages" >> $installerLog

for package in $packages; do
  # check if package is already install
  if dpkg -s $(echo "$package" | sed "s/\"//g") >/dev/null 2>&1; then
    let "i+=2"
    let "progress=$((i * 100 / num_packages / 2))"
    sleep 1 | wtMsg "$defaultTitle" "Package $package is already installed." "gauge" $progress
    echo "Package $package is already installed" >> $installerLog
  else
    let "i+=1"
    let "progress=$((i * 100 / num_packages / 2))"
    sudo apt-get install -y $(echo "$package" | sed "s/\"//g") 2>&1 | tee $tmpLog | tee -a $installerLog | wtMsg "$defaultTitle" "Installing package $package..." "gauge" $progress 
  if grep -q "E:" $tmpLog 2>&1; then
    # Display an error message if there were errors
    fail=true
    let "i+=1"
    let "progress=$((i * 100 / num_packages / 2))"
    wtColors red
    sleep 2 | wtMsg "Error!" "Error installing package: $package. Please check the output file $installerLog for details." "gauge" $progress
    rm $tmpLog
    wtColors $defaultColor
  else
    let "i+=1"
    let "progress=$((i * 100 / num_packages / 2))"
    sleep 1 | wtMsg "$defaultTitle" "Package $package has been installed." "gauge" $progress
  fi
  fi
done

# Install python packages
if wtMsg "Python Packages Installation" "Would you like to install python packages needed?" "yesno"; then
  wtMsg "$defaultTitle" "Installing <adafruit_ads1x15> for battery monitoring and <pynput> to wake up screen while sleeping..." "infobox"
  echo "## Installing <adafruit_ads1x15> for battery monitoring and <pynput> to wake up screen while sleeping..." >> $installerLog
  sudo pip3 install adafruit_ads1x15 pynput | tee $tmpLog | tee -a $installerLog 
  # Check if there were any errors during the update
  if grep -q "ERROR:" $tmpLog 2>&1; then
    wtColors red
    wtMsg "Error!" "Error installing python packages with pip3. Please check the output file $installerLog for details." "msgbox"
    wtColors $defaultColor
    rm $tmpLog
  elif grep -q "already" $tmpLog 2>&1; then
    wtColors green
    wtMsg "$defaultTitle" "Packages seem to be already installed. Please check the output file $installerLog for details." "msgbox"
    rm $tmpLog
    wtColors $defaultColor
  else
    wtColors green
    wtMsg "$defaultTitle" "Python packages installed." "msgbox"
    echo "Python packages installed." >> $installerLog
    wtColors $defaultColor
  fi
fi

# Check if zsh is set as default shell and if not, ask for it.
if [ "$(echo $SHELL)" != "$(which zsh)" ] && wtMsg "$defaultTitle" "Do you want to set zsh as default shell?" "yesno"; then
  echo "## setting zsh as default shell" >> $installerLog
  wtMsg "$defaultTitle" "Setting zsh as default shell... Please enter sudo password." "infobox"

  if [ $(which zsh) ]; then
      echo "zsh was found." >> $installerLog
    if chsh -s $(which zsh); then
      wtColors green
      wtMsg "$defaultTitle" "zsh is now the default shell." "msgbox"
      echo "zsh is now the default shell." >> $installerLog
      wtColors $defaultColor
    else
      wtColors red
      wtMsg "Error." "Error while trying to set zsh as default shell. Please retry." "msgbox"
      echo "Error while trying to set zsh as default shell." >> $installerLog
      wtColors $defaultColor
    fi
  else
    wtColors red
    wtMsg "Error." "zsh was not found. Please try to reinstall it." "msgbox"
    echo "Error: zsh was not found. Please try to reinstall it." >> $installerLog
    wtColors $defaultColor
  fi
else
  wtColors lightgray
  wtMsg "$defaultTitle" "Z shell is already installed and used. Nothing to do." "msgbox"
  wtColors $defaultColor
fi

# if a package failed to install, display a message
if $fail; then
  wtColors red
  echo "There was an error during installing." >> $installerLog
  wtMsg "Package Installation" "There was an error during installing. Please check the output file $installerLog for details." "msgbox"
else
  if test -z "$packages"; then
    wtColors lightgray
    echo "Nothing to install." >> $installerLog
    wtMsg "Package Installation" "Nothing to install." "msgbox"
    return
  fi
  wtColors green
  echo "All packages selected were successfully installed." >> $installerLog
  wtMsg "Package Installation" "All packages selected were successfully installed." "msgbox"
  defaultMenu="Configuration" #highlight next item menu if succeed
fi
}



function installConfig() {

# Check if urxvt is set as default terminal and if not, ask for it.
termDefault="ls -l /etc/alternatives/x-terminal-emulator | grep urxvt >/dev/null"
if ! eval "$termDefault"; then
  if wtMsg "$defaultTitle" "urxvt is not the terminal set by default. Do you want to configure it?" "yesno"; then
    echo "## setting urxvt as default terminal" >> $installerLog
    wtMsg "$defaultTitle" "Setting urxvt as default terminal..." "infobox"
    sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt >> $installerLog
    if [ $(which urxvt) ]; then
      echo "urxvt was found." >> $installerLog
      if eval "$termDefault"; then
        wtColors green
        wtMsg "$defaultTitle" "urxvt is now the default terminal." "msgbox"
        echo "urxvt is now the default terminal." >> $installerLog
        wtColors $defaultColor
      else
        wtColors red
        wtMsg "Error." "Error while trying to set urxvt as default terminal. Please retry." "msgbox"
        echo "Error while trying to set urxvt as default terminal." >> $installerLog
        wtColors $defaultColor
      fi
    else
      wtColors red
      wtMsg "Error." "urxvt was not found. Please try to reinstall it." "msgbox"
      echo "Error: urxvt was not found. Please try to reinstall it." >> $installerLog
      wtColors $defaultColor
    fi
  fi
else
    echo "urxvt is already the default terminal." >> $installerLog
fi

# Check if i2c is enabled. If not, ask for enable it.
if [[ $(sudo raspi-config nonint get_i2c) == 1  ]]; then
  if wtMsg "$defaultTitle" "i2c protocol is disabled. You have to enable it, continue?" "yesno"; then
    echo "## enabling i2c" >> $installerLog
    sudo raspi-config nonint do_i2c 0 | wtMsg "$defaultTitle" "Enabling i2c..." "infobox"
    if [[ $(sudo raspi-config nonint get_i2c) == 0  ]]; then
      wtColors green
      wtMsg "$defaultTitle" "i2c has been enabled." "msgbox"
      echo "i2c has been enabled." >> $installerLog
      wtColors $defaultColor
    else
      wtColors red
      wtMsg "Error." "i2c is still disabled. Please try again or do it with <sudo raspi-config>." "msgbox"
      echo "Error: i2c is still disabled." >> $installerLog
      wtColors $defaultColor
    fi
  fi
else
    echo "i2c is already enabled." >> $installerLog
fi

# Install configuration files
if wtMsg "$defaultTitle" "Do you want to install piComputer configuration files?" "yesno"; then
  echo "## installConfig" >> $installerLog

  # Check if a piComputer configuration folder already exists and ask to backup or remove it
  if [ -d $installPath ]; then   
      if wtMsg "$defaultTitle" "piComputer configuration found. Do you want to backup it?" "yesno"; then
        mv $installPath $HOME/picomputer-backup
        echo -e "piComputer configuration has been backup: $HOME/picomputer-backup" >> $installerLog
        wtMsg "$defaultTitle" "piComputer configuration has been backup: $HOME/picomputer-backup" "msgbox"
      else
        if wtMsg "$defaultTitle" "Delete old picomputer configuration folder?" "yesno"; then
          rm -fr $installPath
          echo "$installPath was removed" >> $installerLog
	fi
      fi
  fi
else
    return
fi

# Create needed directories
makeDirectories="\
$installPath
$HOME/.config/polybar
$HOME/.config/i3
$HOME/.config/dunst
$HOME/.config/rofi
$HOME/.urxvt/ext"

i=0
progress=0
countItems=0

while read -r mdir; do
  let "countItems+=1"
done <<< "$makeDirectories"

while read -r mdir; do
  let "i+=1"
  let "progress=$((i * 100 / countItems))"
  mkdir -p $mdir && sleep .5 | wtMsg "Creating direectories..." "$mdir has been created." "gauge" $progress
  echo "$mdir has been created." >> $installerLog
done <<< "$makeDirectories"

# Copy files
cpDirectories="\
$installerDir/config $installPath
$installerDir/images $installPath
$installerDir/scripts $installPath"

i=0
progress=0
countItems=0

while read -r cpdir; do
  let "countItems+=1"
done <<< "$cpDirectories"

while read -r cpdir; do
  let "i+=1"
  let "progress=$((i * 100 / countItems))"
  cp -r $cpdir && sleep .5 | wtMsg "Copying directories..." "$cpdir has been copied." "gauge" $progress
  echo "$cpdir has been copied." >> $installerLog
done <<< "$cpDirectories"


# Make scripts executable
if chmod +x $installPath/scripts/*; then
  echo "Make scripts executable (chmod +x)" >> $installerLog
fi

#Link configuration files

if wtMsg "$defaultTitle" "Linking configuration files to standard path. This will override all existing configuration files. Continue?  <Yes> You can ignore this message." "yesno"; then
  echo "Linking config files..." >> $installerLog
else
  wtColors red
  echo "Error: Do not want to link config files." >> $installerLog
  wtMsg "Error." "Configuration files have not been linked." "msgbox"
  return
fi

confFiles="\
sudo ln -sf $installPath/config/motd /etc/motd
ln -sf $installPath/config/zshrc $HOME/.zshrc
ln -sf $installPath/config/zprofile $HOME/.zprofile
ln -sf $installPath/config/Xresources $HOME/.Xresources
ln -sf $installPath/config/polybar $HOME/.config/polybar/config
ln -sf $installPath/config/i3 $HOME/.config/i3/config
ln -sf $installPath/config/dunstrc $HOME/.config/dunst/dunstrc
ln -sf $installPath/config/rofi $HOME/.config/rofi/config.rasi
ln -sf $installPath/config/rofi.rasi $HOME/.config/rofi/picomputer.rasi
ln -sf $installPath/config/vimrc $HOME/.vimrc
ln -sf $installPath/config/urxvt-keyboard-select $HOME/.urxvt/ext/keyboard-select
xrdb $HOME/.Xresources"

i=0
progress=0
countItems=0

while read -r cfile; do
  let "countItems+=1"
done <<< "$confFiles"

while read -r cfile; do
  let "i+=1"
  let "progress=$((i * 100 / countItems))"
  $cfile && sleep .5 | wtMsg "Linking configuration files..." "$cfile" "gauge" $progress
  echo "$cfile" >> $installerLog
done <<< "$confFiles"
wtColors green
wtMsg "$defaultTitle" "Done. Configuration files can be found here: $installPath" "msgbox"
defaultMenu="Fonts"

}



installFonts() {

if wtMsg "$defaultTitle" "Do you want to install JetBrains Mono font for piComputer?" "yesno"; then

  echo "## installFonts" >> $installerLog
  echo "Copying fonts to $HOME/.fonts" >> $installerLog
  mkdir -p $HOME/.fonts
  cp -r $installerDir/fonts/JetBrainsMono $HOME/.fonts/
  if fc-list | grep JetBrains; then
  wtColors green
  echo "JetBrains Mono font has been copied ($HOME/.fonts/JetBrainsMono)." >> $installerLog
  wtMsg "$defaultTitle" "JetBrains Mono font has been copied to $HOME/.fonts/JetBrainsMono" "msgbox"
  else
  wtColors red
  echo "JetBrains Mono font has not been found." >> $installerLog
  wtMsg "Error." "JetBrains Mono font has not been found." "msgbox"
  fi
  defaultMenu="Reboot"
else
    return
fi

}

rebootPi() {
wtColors red
if wtMsg "$defaultTitle" "Do you want to reboot piComputer?" "yesno"; then
  reboot
fi
}

outputLog() {
wtColors lightgray
whiptail --backtitle="$topLeftTitle" --title="piComputer installer output log" --scrolltext --textbox $installerLog --ok-button "Go back" $menuHeight $width
}

# Main Menu

while true; do
  wtColors $defaultColor
  choice=$(whiptail --backtitle="$topLeftTitle" --title "piComputer installer" --default-item "$defaultMenu" --ok-button "Select" --cancel-button "Exit" --menu "Choose an option:" $menuHeight $width 6 \
    "Packages" "install needed packages using apt" \
    "Configuration" "install piComputer configuration files" \
    "Fonts" "install JetBrains Mono font" \
    "Reboot" "reboot piComputer" \
    "Output Log" "installer log output" \
    "About" "piComputer $version" \
    3>&1 1>&2 2>&3)


  [[ "$?" = 1 ]] && break; # exit if canceled

  case $choice in
      "Packages")
          installPackages
          ;;
      "Configuration")
          installConfig
          ;;
      "Fonts")
          installFonts
          ;;
      "Reboot")
          rebootPi
          ;;
      "Output Log")
          outputLog
          ;;
      "About")
          piComputerSplash
          ;;
  esac
done
