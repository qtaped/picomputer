#!/bin/bash

# Terminate already running bar instances

if [[ $(pgrep -x polybar) ]]
then
killall -q polybar-msg
killall -q polybar
sleep 1
fi

polybar top 

echo "Polybar launched..."
