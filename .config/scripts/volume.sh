#!/usr/bin/env /bin/sh

VOLUME=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}')
notification_id="/tmp/VOLUME_NOTIFICATION_ID"
if [ ! -s $notification_id ]; then
        # The file is empty.
        echo 1 > $notification_id
fi

case $1 in 
    up)
        wpctl set-volume -l 1 @DEFAULT_SINK@ $2%+
        ;;
    down)
        wpctl set-volume @DEFAULT_SINK@ $2%-
        ;;
    mute)
        wpctl set-mute @DEFAULT_SINK@ toggle
        ;;
esac

if [[ $(wpctl get-volume @DEFAULT_SINK@ | awk '{print $3}') == '[MUTED]' ]]; then
    notify-send \
        "Volume: MUTED" \
        -r $(<$notification_id) \
        -i notification-audio-volume-muted \
        -t 1000 \
        -h string:synchronous:volume-change \
        -a "volume_notification_script" \
        -p > $notification_id
else
    VOLUME=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print 100 * $2}')
    VOLUME_ICON="notification-audio-volume-medium"
    if [ "$VOLUME" -le 30 ]; then VOLUME_ICON="notification-audio-volume-low"; fi
    if [ "$VOLUME" -ge 75 ]; then VOLUME_ICON="notification-audio-volume-high"; fi
    if [ "$VOLUME" -le 1 ]; then VOLUME_ICON="notification-audio-volume-muted"; fi
    notify-send \
        "Volume: $VOLUME%"  \
        -r $(<$notification_id) \
        -t 1000 \
        -i $VOLUME_ICON \
        -h int:value:"$VOLUME" \
        -h string:synchronous:volume-change \
        -a "volume_notification_script"\
        -p > $notification_id

fi
