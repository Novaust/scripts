#!/bin/bash

function battery() {
	dir=/sys/class/power_supply
	exist=$(ls -F $dir | grep '/$' | grep 'BAT' | wc -w)
	if [ $exist -gt 0 ]; then
		path=$dir/BAT1	# change BAT1 to the name of your own battery
		batCharge=$(cat $path/capacity); batStatus=$(cat $path/status)
		iconList=""; icon=""
		if [ "$batStatus" = "Charging" ]; then echo " $batCharge%"
		elif [ "$batStatus" = "Discharging" ]; then
            pos=$(( $batCharge / 10 ))
            icon=${iconList:$pos:1}
			echo "$icon $batCharge%"
		fi
	else 
        echo " No BAT"; 
    fi
}

function cmus() {
	program=$(ps -C cmus --no-header | wc -l)
	if [ $program -gt 0 ]; then
		artist=$(cmus-remote -Q | grep 'tag artist' | sed 's/tag artist //g')
		title=$(cmus-remote -Q | grep 'tag title' | sed 's/tag title //g')
		playStatus=$(cmus-remote -Q | grep 'status' | sed 's/status //g')
		random=$(cmus-remote -Q | grep 'set shuffle' | sed 's/set shuffle //g')

		[ "$playStatus" = "playing" ] && playStatus="契" || playStatus=""
		[ "$random" = "true" ] && random="咽" || random="劣"
		echo "$playStatus $random $artist - $title"
	fi
}

function volume() {
	vol=$(amixer -M sget Master | tail -n 1 | awk -F 'Left:|[][]' '{ print $2 }')
	mute=$(amixer -M sget Master | tail -n 1 | awk -F 'Left:|[][]' '{ print $6 }')
	[ "$mute" = "off" ] && echo "婢 $vol" || echo "墳 $vol" 
}

function dateTime() {
	echo "⏽ $(date "+%b %d %a %H:%M")"
}

function ariaStatus() {
    path=/home/novaust/.config/aria2
    status=$(ps -C aria2c --no-header | wc -l)
    count=0
    if [ $status -eq 1 ]; then
        list=$(cat $path/aria2.session | grep "gid")
        for str in $list; do let count++; done
        echo " $count"
    fi
}

function detectUSB() {
	list=$(lsblk -S | grep "usb" | wc -l)
	[ $list -gt 0 ] && echo "禍$list"
}

# customize the status bar
arrayFunc=(
	"cmus"
	"detectUSB"
    "ariaStatus"
	"volume"
	#"battery"
	"dateTime"
)

# main
sep=" "
while true; do
	display=""
	for func in "${!arrayFunc[@]}"; do
		str=$(${arrayFunc[$func]})
		[ -n "$str" ] && display=$display$sep$str
	done
	xsetroot -name "$display"
	sleep 1
done
