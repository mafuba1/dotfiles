#!/bin/bash

BAT="/sys/class/power_supply/BAT$1"

if [ -d "$BAT" ]; then
    capacity=$(cat "$BAT/capacity")
    status=$(cat "$BAT/status")

    if [ "$status" = "Charging" ]; then
        icon=""  # Plug icon
    else
        case $capacity in
            9[0-9]|100) icon="" ;;  # Full
            7[0-9]|8[0-9]) icon="" ;; # 70–89
            5[0-9]|6[0-9]) icon="" ;; # 50–69
            2[0-9]|3[0-9]|4[0-9]) icon="" ;; # 20–49
            *) icon="" ;;               # <20%
        esac
    fi

    echo "$icon $capacity%"
else
    echo " No Battery"
fi

