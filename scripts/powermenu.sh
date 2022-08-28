#!/bin/bash
# powermenu for piComputer
# more in .picomputer/config/i3

# time in seconds before sleep
timeOut="300"
Cycle="600"

xsetq=$(xset q | grep timeout |  awk '{print $2;}')

# display powermenu with dunst notification
case "$1" in

  --menu)

if [[ $xsetq == 0 ]]; then
xsetStatus="off"
else
xsetStatus="on ($timeOut\s)"
fi

dunstify -u critical -h string:x-dunst-stack-tag:powermenu \
" ⌄     POWER MENU" \
"    ----------------\n\
[<b>X</b>]set is <i>$xsetStatus</i>\n\
[<b>S</b>]creen off\n\
[<b>L</b>]ock session\n\
[<b>E</b>]xit session\n\n\
[<b>R</b>]eboot\n\
[<b>P</b>]oweroff"
  ;;

# set xset time
  --xset)
xset s $timeOut $Cycle
;;

# toggle xset on/off
  --toggle)

if [[ $xsetq == 0 ]]; then
xset s $timeOut $Cycle
else
xset s 0 0
fi

# refresh menu
exec ~/.picomputer/scripts/powermenu.sh --menu
  ;;

  *) printf "..." ;;

esac
exit 0
