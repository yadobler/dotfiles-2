#!/usr/bin/env zsh
case $1 in 
    up)
        light -A $2
        ;;

    down)
        light -U $2
    ;;
esac

notification_id="/tmp/BRIGHTNESS_NOTIFICATION_ID"
[[ ! -a $notification_id ]] && echo 1 > $notification_id
light_val=$(light | awk '{print int($1)}')
light_val_ICON="notification-display-brightness-medium"
if [ $light_val -le 40 ]; then light_val_ICON="notification-display-brightness-low"; fi
if [ $light_val -le 15 ]; then light_val_ICON="notification-display-brightness-off"; fi
if [ $light_val -ge 65 ]; then light_val_ICON="notification-display-brightness-high"; fi
if [ $light_val -ge 90 ]; then light_val_ICON="notification-display-brightness-full"; fi
notify-send \
    "Brightness: $light_val% " \
    -r $(<$notification_id) \
    -t 1000 \
    -i $light_val_ICON \
    -h int:value:$light_val \
    -h string:synchronous:brightness-change \
    -a "brightness_notification_script"\
    -p > $notification_id

