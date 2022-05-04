#!/bin/sh

if [ "$(pgrep -x mocp)" ]; then

state=$(mocp -Q %state)
artist=$(mocp -Q %artist)
song=$(mocp -Q %song)
 
if [ $state = 'PLAY' ]; then
   state_icon=""
elif [ $state = 'PAUSE' ]; then
   state_icon=""
else
   state_icon=""
fi

if [ "$artist" ] && [ "$song" ]; then
infos=$(mocp -Q "%song - %artist")
else
infos=$(mocp -Q "%song")
fi

printf " $state_icon  $infos"
else
printf "Nope."
fi
exit 0
