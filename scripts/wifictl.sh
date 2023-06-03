#!/bin/bash

# piComputer simple wifi script
# https://github.com/qtaped

title="piComputer wifi manager"
echo -e '\033]2;'$title'\007'

wifiSplash() {

clear
echo -e "\033[38;5;3m\n\
         _  __ _    \n\
 __ __ _(_)/ _(_)   \n\
 \ V  V / |  _| |_  \n\
  \_/\_/|_|_| |_(_) \n"

echo " $title"
echo -e "\033[0m"
sleep 1

}

# default interface
wifiInterface=wlan0
wpaConfig=/etc/wpa_supplicant/wpa_supplicant.conf

# whiptail options
wSize="12 68"
defaultColor="brown"

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

wifiSplash

# Functions

getSSID() {
 ssid=$(wpa_cli -i $wifiInterface status | grep "^ssid" | sed "s/ssid=//")
 if [[ -n $ssid ]];then
 show_ssid="SSID: $ssid"
 else
 show_ssid="Not connected"
 fi
}

# Function to scan for available Wi-Fi networks
scanWifi() {
  networks=$(sudo iwlist $wifiInterface scan | awk -F'"' '/ESSID/{print $2}')
}

# Function to display the network selection dialog
selectNetwork() {
  local options=()
  while IFS= read -r network; do
    if [[ -n "$network" ]]; then
      options+=("$network" "")
    fi
  done <<< "$networks"

  options+=("<Other network>" "?")

  selected=$(whiptail --backtitle="$topLeftTitle" --ok-button "Connect" --menu "Select a network:" $wSize 4 "${options[@]}" 3>&1 1>&2 2>&3)
  if [[ "$selected" == "<Other network>" ]]; then
  network=$(whiptail --inputbox "Enter the name of network:" $wSize 3>&1 1>&2 2>&3)
  else
  network="$selected"
  fi
}

enterPassword() {
  password=$(whiptail --title "Wi-Fi Password" --passwordbox "Enter the password for the selected network (8-63 characters). Or leave it empty if none." $wSize 3>&1 1>&2 2>&3)
}

changeInterface() {
  wifiInterface=$(whiptail --title "Wi-Fi Interface" --inputbox "Enter the name of wireless interface: (default: wlan0)" $wSize "$wifiInterface" 3>&1 1>&2 2>&3)
  if [[ -z "$wifiInterface"  ]]; then
  wifiInterface="wlan0"
  fi
}

wpaReconfigure() {
  if sudo wpa_cli -i $wifiInterface reconfigure; then
  wtColors green
  whiptail --backtitle "$topLeftTitle" --msgbox "wpa_cli configuration has been reload." $wSize
  else
  wtColors red
  whiptail --backtitle "$topLeftTitle" --msgbox "Error. Cannot reload wpa_cli configuration. Wrong interface?" $wSize
  fi
}

# Function to connect to the selected network
connectNetwork() {
  if [[ -n "$network" && -n "$password" ]]; then
    echo | sudo tee -a $wpaConfig >/dev/null
    wpa_passphrase "$network" "$password" | sudo tee -a $wpaConfig >/dev/null
    wpaReconfigure
    wtColors green
    whiptail --title "Wireless network added" --msgbox "$network has been added to $wpaConfig" $wSize;
  elif [[ -n "$network" && -z "$password" ]]; then
    echo  | sudo tee -a $wpaConfig >/dev/null
    echo network={ | sudo tee -a $wpaConfig >/dev/null
    echo -e "\tssid=\"${network}\"" | sudo tee -a $wpaConfig >/dev/null
    echo -e "\tkey_mgmt=NONE" | sudo tee -a $wpaConfig >/dev/null
    echo "}" | sudo tee -a $wpaConfig >/dev/null
    wpaReconfigure
    wtColors green
    whiptail --title "Wireless network added" --msgbox "$network has been added to $wpaConfig without password." $wSize;
  else
    wtColors red
    whiptail --backtitle "$topLeftTitle" --msgbox "No valid network or password provided." $wSize
  fi
}


listConnectWifi() {
  
scanWifi
selectNetwork

# Check if a network has been selected
if [[ -n "$network" ]]; then

enterPassword
# validate the password length
if [[ -n "$password" ]]; then
  while ((${#password} < 8 || ${#password} > 63)); do
    password=""
    wtColors red
    if whiptail --backtitle "$topLeftTitle" --title "Invalid Password" --yesno "Password must be 8 to 63 characters long. Retry?" $wSize; then
    wtColors $defaultColor
    enterPassword
    else
    break
    fi
  done
fi

  # confirm network connection
if [[ -z "$password" ]]; then
  whiptail --title "Confirm Network Connection" --yesno "Are you sure you want to connect to \"$network\" without password?" $wSize
else
  whiptail --title "Confirm Network Connection" --yesno "Are you sure you want to connect to \"$network\"?" $wSize
fi
  local choice=$?
  if [[ $choice -ne 0 ]]; then
    network=""
    password=""
  fi

  connectNetwork

else
  wtColors red
  whiptail --backtitle "$topLeftTitle" --msgbox "No network selected." $wSize
fi


}

getInterface() {

if ifconfig -s | grep -w $wifiInterface; then
  upDown="down"
else
  upDown="up"
fi

}

toggleInterface() {

if ifconfig -s | grep -w $wifiInterface; then
  wtColors green
  if whiptail --title "Wifi interface" --yesno "$wifiInterface is up. Do you want to turn it down?" $wSize; then
  sudo ifconfig $wifiInterface down
  fi
else
  wtColors red
  if whiptail --title "Wifi interface" --yesno "$wifiInterface is down. Do you want to turn it up?" $wSize; then
  sudo ifconfig $wifiInterface up
  wpaReconfigure
  fi
fi

}

# Main Menu

while true; do
  getSSID
  getInterface
  topLeftTitle="Interface: $wifiInterface | $show_ssid"
  wtColors $defaultColor
  choice=$(whiptail --backtitle="$topLeftTitle" --ok-button "Select" --cancel-button "Exit" --menu "piComputer wifi manager" $wSize 3 \
    "Connect" "list wireless networks & connect" \
    "Toggle" "turn $upDown <$wifiInterface> interface" \
    "Interface" "change wireless interface" \
    "Configuration" "edit networks manually" \
    "Reload" "reload wpa configuration" \
    3>&1 1>&2 2>&3)


  [[ "$?" = 1 ]] && break; # exit if canceled

  case $choice in
      "Connect")
          listConnectWifi
          ;;
      "Toggle")
          toggleInterface
          ;;
      "Interface")
         changeInterface 
          ;;
      "Configuration")
          sudo editor $wpaConfig
          ;;
      "Reload")
          wpaReconfigure
          ;;
  esac
done

