#!/usr/bin/env /bin/sh
export XDG_DATA_HOME="/home/yukna/.local/share"
pidof wofi && kill $(pidof wofi) || wofi --show drun --insensitive --style ~/.config/wofi/style.css 
