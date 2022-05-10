#!/bin/bash

title="shutdown"
echo -e '\033]2;'$title'\007'

restart="systemctl reboot"
poweroff="systemctl poweroff"

splash() {
clear
echo "       _           _      _                       "
echo "   ___| |__  _   _| |_ __| | _____      ___ __    "
echo "  / __| '_ \| | | | __/ _  |/ _ \ \ /\ / / \_ \   "
echo "  \__ \ | | | |_| | || (_| | (_) \ V  V /| | | |  "
echo "  |___/_| |_|\__ _|\__\__ _|\___/ \_/\_/ |_| |_(_)"
echo
echo -e "  \e[1;44m r\e[0meboot \e[1;41m p\e[0moweroff ? or (q)uit."
}

while true
do
splash
echo -e "$msg"
echo -e "\e[1;30;47m"
read -p "→ Enter your choice:" -n 1 n
echo -e "\e[0m"

case $n in

	[rR]* ) echo -e "\nRestart."
	exec $restart;;

	[pP]* ) echo -e "\nPoweroff."
	exec $poweroff;;

	[cCqQ]* ) echo -e "\n:(\n"
	exit 0;;

	* ) 
	msg="\n  \e[91mWrong choice.\e[0m Please enter r, p or (q)uit.";;

	esac
done
