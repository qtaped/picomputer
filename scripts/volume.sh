#!/bin/bash
# changeVolume

# Set tag to notification
dunstTag="string:x-dunst-stack-tag:volumechange"

# Ascii bar

# Change the volume using alsa(might differ if you use pulseaudio)
amixer set Master $@ > /dev/null

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(amixer get Master | tail -1 | awk '{print $5}' | sed 's/[^0-9]*//g')"
mute="$(amixer get Master | tail -1 | awk '{print $6}' | sed 's/[^a-z]*//g')"
bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
if [[ $volume == 0 || "$mute" == "off" ]]; then
    # Show the sound muted notification
    dunstify -a "changeVolume" -t 1500 -i notification-audio-volume-muted -h "$dunstTag" "Mute" 
elif [[ $volume -lt 12  ]]; then
    dunstify -a "changeVolume" -t 1500 -i notification-audio-volume-low -h "$dunstTag" "Vol. ─" 
else
    # Show the volume notification
 #   dunstify -a "changeVolume" -t 1000 -u low -i audio-volume-high -h "$dunstTag" -h int:value:"$volume" "Volume : $volume%"
    dunstify -a "changeVolume" -t 1000 -i notification-audio-volume-high -h "$dunstTag" "Vol. $bar"
fi
