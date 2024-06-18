#! /usr/bin/env bash
wallpaper=$1
rm -f ~/Pictures/Wallpaper/cropped-image.png
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

convert $wallpaper -crop $DIMENSION ~/Pictures/Wallpaper/cropped-image.png
kill $(pidof wbg)
wbg ~/Pictures/Wallpaper/cropped-image.png &
wallust run ~/Pictures/Wallpaper/cropped-image.png $2
kill $(pidof waybar); waybar &

