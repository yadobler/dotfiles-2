#!/bin/zsh
VOLUME=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}')
notification_id="/tmp/VOLUME_NOTIFICATION_ID"
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
    notify-send.sh \
        -R $notification_id \
        -i $VOLUME_ICON \
        -a "volume_notification_script" \
        -t 1000 \
        "Volume: MUTED" \
        -h string:synchronous:volume-change
else
    # HACK: using zsh for FPA - if using sh, change these lines
    zmodload zsh/mathfunc
    VOLUME=$(( int(100 * float($(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}'))) ))
    VOLUME_ICON="audio-volume-medium"
    if [ $VOLUME -le 30 ]; then VOLUME_ICON="audio-volume-low"; fi
    if [ $VOLUME -ge 75 ]; then VOLUME_ICON="audio-volume-high"; fi
    if [ $VOLUME -le 1 ]; then VOLUME_ICON="audio-volume-muted"; fi
    notify-send.sh \
        -R $notification_id \
        -i $VOLUME_ICON \
        -a "volume_notification_script" \
        -t 1000 \
        "Volume: $VOLUME%"  \
        -h int:value:$VOLUME \
        -h string:synchronous:volume-change
fi
