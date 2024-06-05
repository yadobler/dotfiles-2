#!/usr/bin/env zsh
VOLUME=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}')
notification_id="/tmp/VOLUME_NOTIFICATION_ID"
[[ ! -a $notification_id ]] && echo 1 > $notification_id
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
    # HACK: using zsh for FPA - if using sh, change these lines
    zmodload zsh/mathfunc
    VOLUME=$(( int(100 * float($(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}'))) ))
    VOLUME_ICON="notification-audio-volume-medium"
    if [ $VOLUME -le 30 ]; then VOLUME_ICON="notification-audio-volume-low"; fi
    if [ $VOLUME -ge 75 ]; then VOLUME_ICON="notification-audio-volume-high"; fi
    if [ $VOLUME -le 1 ]; then VOLUME_ICON="notification-audio-volume-muted"; fi
    notify-send \
        "Volume: $VOLUME%"  \
        -r $(<$notification_id) \
        -t 1000 \
        -i $VOLUME_ICON \
        -h int:value:$VOLUME \
        -h string:synchronous:volume-change \
        -a "volume_notification_script"\
        -p > $notification_id

fi
