#!/usr/bin/env /bin/sh
grim -g "$(hyprctl activewindow | jq -j '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | tee ~/Pictures/Screenshots/$(date +'%Y%m%d-%H%M%S')-original.png | swappy -f -
