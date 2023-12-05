#!/bin/bash
case $1 in 
    up)
        light -A $2
        ;;

    down)
        light -U $2
    ;;
esac

notification_id="/tmp/BRIGHTNESS_NOTIFICATION_ID"
light_val=$(light | awk '{print int($1)}')
notify-send.sh \
    "Brightness: $light_val% " \
    -R $notification_id \
    -t 1000 \
    -i brightnesssettings.svg \
    -h int:value:$light_val \
    -h string:synchronous:brightness-change \
    -a "brightness_notification_script"
