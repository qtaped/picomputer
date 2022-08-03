#!/bin/bash

# Lock Screen script

$HOME/.picomputer/scripts/sleepscreen.py

pkill -u "$USER" -USR1 dunst

i3lock -e -i $HOME/.picomputer/images/background.png --nofork

pkill -u "$USER" -USR2 dunst
