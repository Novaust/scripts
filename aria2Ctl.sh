#!/bin/bash

cmdPath=/home/novaust/scripts/ariaComplete.sh
confPath=/home/novaust/.config/aria2/aria2.conf
list=$(curl -s -k "https://trackerslist.com/all_aria2.txt")

if [ -z "$(grep "bt-tracker" $confPath)" ]; then
    sed -i '$a bt-tracker='${list} $confPath
else
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" $confPath
fi

aria2c --conf-path=$confPath -D \
    --on-download-complete=$cmdPath
while true; do
    if [ $(ps -C aria2c --no-header | wc -l) -eq 0 ]; then
        dunstify "Aria2:Restart"
        aria2c --conf-path=$confPath -D \
            --on-download-complete=$cmdPath
    fi
    sleep 15
done
