#!/bin/bash


icon_low=sunny
icon_medium=sunny
icon_high=sunny

function send_notification {
    brightness=$(brightnessctl -m | awk -F, '{print $4}' | awk -F% '{print $1}')

    if [ "$brightness" -lt "35" ]; then
        icon_chosen=$icon_low
    else
        if [ "$brightness" -lt "70" ]; then
            icon_chosen=$icon_medium
        else
            icon_chosen=$icon_high
        fi 
    fi 
        bar=$(seq -s "─" $(($brightness/5)) | sed 's/[0-9]//g')
        bar2=$(seq -s " " $((20-$(($brightness/5)))) | sed 's/[0-9]//g')
        dunstify "$bar$bar2 $(printf '%3.d' $brightness)% " -i $icon_chosen -r 6969
}


case $1 in
    up)
        brightnessctl s +2%
        send_notification
        ;;
    down)
        brightnessctl s 2%-
        send_notification
        ;;
esac
