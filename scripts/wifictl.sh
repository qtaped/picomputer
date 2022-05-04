#!/bin/bash
# Simple iwctl shortcuts

title="wifi control"
echo -e '\033]2;'$title'\007'

# wifi card id
wifi_card=wlan0

# list networks
reload_interface () {
clear
iwctl station $wifi_card get-networks
}

reload_interface
# do something?

while true; do

echo -e "\e[1;44m s\e[0mcan,  \e[1;42m c\e[0monnect, \e[1;41m d\e[0misconnect, \e[1;43m o\e[0mther? or (q)uit."
echo -e "\e[1;30;47m"
read -p "Enter your choice:" -n 1 action
echo -e "\e[0m"

   case $action in

[s]* ) 
        reload_interface
        echo -n "Scanning... "
        iwctl station $wifi_card scan on
        sleep 2
        reload_interface
        echo -e "\e[94mScan on.\e[0m\n";;
[S]* ) 
        iwctl station $wifi_card scan off
        reload_interface
        echo -e "\e[91mScan off.\e[0m\n";;

[cC]* ) 
       reload_interface
       echo "(Leave blank and hit return to cancel.)"
       read -p "Enter SSID: " ssid 
if [ -z $ssid ]; then
reload_interface
echo -e "Canceled.\n"
else
       iwctl station $wifi_card connect $ssid
       reload_interface
       echo -e "\e[92mReaching $ssid\e[0m\n"
fi;;   
[dD]* ) 
        reload_interface
        iwctl station $wifi_card disconnect
        echo -e "\e[91m[$wifi_card]\tDisconnected.\e[0m\n";;

[oO]* ) 
        iwctl
        reload_interface;;

[qQ]* ) exit;;

* )     reload_interface
        echo -e "\e[91mWrong choice.\e[0m\n";;

   esac

done
