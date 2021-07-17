#!/bin/bash

#dunstify id -> 500-550

diskList1=""; diskList2=""; diskDiff=""

function monitor() {
	name="/dev/$1"; mountDir=""; umounted=true
	htcl=$(lsblk -S | grep "$1" | awk '{print $2}')
	part=$(lsblk -x name | grep "$1" | grep "part" | awk '{print $1}')

	while true; do
		df=$(df -lh | grep "$1")
		if [ ! -d "/sys/class/scsi_disk/$htcl" ]; then
			if [ -n "$df" ]; then
				dunstify -r 501 -t 5000 "警告:检测到设备$1挂载下弹出,请手动处理"
				break
			else
				dunstify -r 502 -t 5000 "设备$1正常拔出"
				break
			fi
		else
			if [ ! -n "$df" ] && [ "$umounted" = "false" ]; then 
				dunstify -r 503 -t 5000 "设备$1已卸载"
				umounted=true
			elif [ -n "$df" ] && [ "$umounted" = "true" ]; then
				umounted=false
			fi
		fi
		sleep 0.2
	done
}

#main
while true; do
	if [ -d "/proc/scsi/usb-storage" ]; then
		diskList2=$(lsblk -S | grep "usb" | awk '{print $1}')
		diskDiff=$(diff <(echo "$diskList1") <(echo "$diskList2") | grep ">" | sed "s/> //g")
		if [ -n "$diskDiff" ]; then
			for str in $diskDiff; do
				monitor $str &
				dunstify -r 504 -t 5000 "检测到USB设备插入 - $str"
			done
		fi
		diskList1=$diskList2
	fi
	sleep 0.5
done
