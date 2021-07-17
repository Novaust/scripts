#!/bin/bash

function display() {
	mute=$(amixer -M sget Master | tail -n 1 | awk -F 'Left:|[][]' '{ print $6 }')
	vol=$(amixer -M sget Master | tail -n 1 | awk -F 'Left:|[][]' '{ print $2 }' | sed 's/%//g')
	urgency=""; progressValue=""

	if [ "$mute" = "on" ]; then 
		urgency="normal"
		progressValue=" $vol%"
	else
		urgency="low"
		progressValue="mute"
	fi

	dunstify -t 1500 -r 66 -u $urgency -h int:value:$vol "Volume:$progressValue"

}

case $1 in
	up)
		amixer -q -M sset Master 5%+
		;;
	down)
		amixer -q -M sset Master 5%-
		;;
	toggle)
		amixer -q set Master toggle
		;;
esac

display

