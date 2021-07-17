#!/bin/bash

function display() {
	brightness=$(xrandr --verbose | grep "Brightness" | awk '{print $2}' | head -c 3)
	brightValue=$(echo "$brightness * 200 - 100" | bc)

	dunstify -r 63 -u normal -t 1500 -h int:value:$brightValue "Brightness: $brightness"
}

function changeValue() {
	screen=$(xrandr | grep " connected" | cut -f1 -d " ")
	value=$(xrandr --verbose | grep "Brightness" | awk '{print $2}' )

	# The brightness level should be set between 0.5 to 1 better visibility
	case $1 in
		up)
			data=$(awk -v value="$value" 'BEGIN{print value+0.1}')
			if [ `echo "$value < 1.0" | bc` -eq 1 ]; then
				xrandr --output $screen --brightness $data
			fi
			;;
		down)
			data=$(awk -v value="$value" 'BEGIN{print value-0.1}')
			if [ `echo "$value > 0.5" | bc` -eq 1 ]; then
				xrandr --output $screen --brightness $data
			fi
			;;
	esac
}

case $1 in
	up)
		changeValue up
		;;
	down)
		changeValue down
		;;
esac

display
