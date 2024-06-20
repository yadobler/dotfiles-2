#! /usr/bin/env bash
wallpaper=$1
wallpaper_cropped=~/Pictures/Wallpaper/cropped-image.png
rm -f $wallpaper_cropped
HEIGHT=$(identify -ping -format "%h" "$wallpaper")
WIDTH=$(identify -ping -format "%w" "$wallpaper")

# Which portion to start (0.0 top - 1.0 bottom)
PORTION_RATIO=0.75

# Screen ratio - 3000/2000
SCREEN_RATIO="3/2"

# using python to round off numbers, so might as well use it for all
w=$WIDTH
h=$HEIGHT
x=0
y=0
ratio=$SCREEN_RATIO

if (( $(bc <<< "$w / $h < $ratio") )); then
    w=$WIDTH
    h=$(bc <<< "scale=2; $w / $ratio")
    x=0
    y=$(bc <<< "$PORTION_RATIO * ($HEIGHT - $w / $ratio)")
else
    w=$(bc <<< "$HEIGHT * $ratio")
    h=$HEIGHT
    x=$(bc <<< "$PORTION_RATIO * ($WIDTH - $HEIGHT * $ratio)")
    y=0
fi

DIMENSION=$(bc <<< "scale=0; $w")x$(bc <<< "scale=0; $h")+$(bc <<< "scale=0; $x")+$(bc <<< "scale=0; $y")

convert $wallpaper -crop $DIMENSION $wallpaper_cropped
kill $(pidof wbg)
wbg $wallpaper_cropped &
wallust run $wallpaper_cropped $( [ -n "$2" ] && echo "-p $2" )
# TODO: make dunstrc into 2 step merge between settings and colors
kill $(pidof waybar); waybar &
kill $(pidof dunst)
