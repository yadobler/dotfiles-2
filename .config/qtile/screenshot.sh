#!/bin/bash

case $1 in
    screen)
        filepath=~/Pictures/screenshot/screen_$(date +%Y-%m-%d-%T).png
        maim -u $filepath 
        ;;
    area)
        filepath=~/Pictures/screenshot/area_$(date +%Y-%m-%d-%T).png
        maim -s $filepath 
        ;;
    window)
        filepath=~/Pictures/screenshot/window_$(xprop WM_CLASS -id $(xdotool getactivewindow) | cut -d '"' -f2)_$(date +%Y-%m-%d-%T).png
        maim -u -i $(xdotool getactivewindow) $filepath 
        ;;
esac
