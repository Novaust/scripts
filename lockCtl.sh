#!/bin/bash

resetTime(){
	while true; do
		exist=$(ps -C i3lock --no-header |wc -l)
		[ $exist -eq 0 ] && xautolock -restart && break
		sleep 2
	done
}

exist=$(ps -C i3lock --no-header |wc -l)
case $1 in
	autostart)
		[ $exist -eq 0 ] && xautolock -time 10 \ 
            -locker "betterlockscreen -l dimblur" \
			-corners 0-0- -cornersize 30 -detectsleep &
		;;
	manual)
		[ $exist -eq 0 ] && betterlockscreen -l dimblur && resetTime
		;;
esac
