#!/bin/bash

title="shutdown."
echo -e '\033]2;'$title'\007'

sleep="systemctl suspend"
hibernate="systemctl hibernate"
restart="systemctl reboot"
poweroff="systemctl poweroff"

echo "     _           _      _                       "
echo "    | |         | |    | |                      "
echo " ___| |__  _   _| |_ __| | _____      ___ __    "
echo "/ __| '_ \| | | | __/ _  |/ _ \ \ /\ / / \_ \   "
echo "\__ \ | | | |_| | || (_| | (_) \ V  V /| | | |_ "
echo "|___/_| |_|\__ _|\__\__ _|\___/ \_/\_/ |_| |_(_)"
echo "                                                "


echo -e "\n\e[1;44m s\e[0muspend  \e[1;43m r\e[0meboot  \e[1;42m h\e[0mibernate  \e[1;41m p\e[0moweroff ? or (q)uit."

while true
do

echo -e "\e[1;30;47m"
read -p "Enter your choice:" -n 1 n
echo -e "\e[0m"

case $n in
	[sS]* ) echo -e "\nSuspend."
	exec $sleep
	break;;

	[hH]* ) echo -e "\nHibernate."
	exec $hibernate
	break;;

	[rR]* ) echo -e "\nRestart."
	exec $restart;;

	[pP]* ) echo -e "\nPoweroff."
	exec $poweroff;;

	[cCqQ]* ) echo -e "\nCanceled.\n"
	exit 0;;

	* ) echo -e "\n\e[91mWrong choice.\e[0m\n"
	    echo -e "Please enter s,h,r,p or (q)uit.";;

	esac
done
