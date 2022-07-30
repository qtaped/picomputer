#!/bin/bash
dunstTag="string:x-dunst-stack-tag:lockmode"

case "$1" in
  on)
i3-msg 'workspace 0'
dunstify -u critical -i emblem-locked "Lock mode enabled." "Press win+alt+esc to unlock." -h "$dunstTag"
        ;;
  off)
i3-msg 'workspace 1'
dunstify -i emblem-unlocked "Lock mode disabled." -h "$dunstTag"
        ;;
  *)
        exit 0
        ;;
esac
exit 0
