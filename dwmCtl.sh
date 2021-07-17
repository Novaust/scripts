#!/bin/sh

case $1 in
	dwmstart)
		while true; do
			dwm 2> ~/.dwm.log
		done
		;;
	dwmexit)
		msg="Click here to exit dwm"
		data=$(dunstify -r 6333 -a default -A 'Y,yes' "$msg")
		[ $data = "Y" ] && killall dwmCtl.sh
		;;
esac

