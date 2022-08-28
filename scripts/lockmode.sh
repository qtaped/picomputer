#!/bin/bash
dunstTag="string:x-dunst-stack-tag:lockmode"

case "$1" in
  on)
i3-msg 'workspace 0'
dunstify -u critical "piComputer is locked." "Press win+alt+esc to unlock." -h "$dunstTag"
        ;;
  off)
i3-msg 'workspace 1'
dunstify -t 1500 "piComputer has been unlocked." -h "$dunstTag"
        ;;
  *)
        exit 0
        ;;
esac
exit 0
