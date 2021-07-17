#!/bin/bash

#desktop
feh --bg-fill ~/Pictures/wallpaper-arch-1.png &
picom -b --experimental-backends
#scripts
~/scripts/nov-status-light.sh &
~/scripts/usbCtl.sh &
~/scripts/lockCtl.sh autostart &
~/scripts/aria2Ctl.sh &
#background
nm-applet &
xfce4-power-manager &
#wait
sleep 3
fcitx5 &
