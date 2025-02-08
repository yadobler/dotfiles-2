#!/bin/bash

icon_muted=audio-volume-muted
icon_low=audio-volume-low
icon_medium=audio-volume-medium
icon_high=audio-volume-high

current_sink=$(pactl get-default-sink)

function get_volume {
    pactl get-sink-volume ${current_sink} | grep % | awk -F% '{print $1}' | awk -F/ '{print $NF}' | xargs
}

function is_muted {
    pactl get-sink-mute ${current_sink} | awk '{print $NF}'
}

function send_notification {
    volume=$(get_volume)
    muted=$(is_muted)
    if [ "$volume" = "0" ] || [ "$muted" = "yes" ]; then
        dunstify " muted" -i $icon_muted -r 6969 
    else
        if [ "$volume" -lt "35" ]; then
            icon_chosen=$icon_low
        else
            if [ "$volume" -lt "70" ]; then
                icon_chosen=$icon_medium
            else
                icon_chosen=$icon_high
            fi 
        fi 

        bar=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')
        bar2=$(seq -s " " $((20-$(($volume/5)))) | sed 's/[0-9]//g')
        dunstify "$bar$bar2 $(printf '%3.d' $volume)% " -i $icon_chosen -r 6969
    fi
}


case $1 in
    up)

        if [ "$(get_volume)" -lt "98" ]; then
            pactl set-sink-volume ${current_sink} +3% 
        else
            pactl set-sink-volume ${current_sink} 100% 
        fi
        send_notification
        ;;
    down)
        pactl set-sink-volume ${current_sink} -3% 
        send_notification
        ;;

    toggle_mute)
        pactl set-sink-mute ${current_sink} toggle
        send_notification
        ;;
    volume)
        send_notification
        ;;
esac
