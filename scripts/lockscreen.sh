#!/bin/bash

# Lock Screen script

pkill -u "$USER" -USR1 dunst

i3lock -i $HOME/.dotfiles/images/background.png --nofork

pkill -u "$USER" -USR2 dunst
