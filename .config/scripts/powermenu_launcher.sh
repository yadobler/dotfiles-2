#! /usr/bin/env zsh
export XDG_DATA_HOME="/home/yukna/.local/share"
pidof wofi && kill $(pidof wofi) || wofi --show drun -GiD key_expand=Tab --allow-images
