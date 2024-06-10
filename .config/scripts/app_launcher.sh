#! /usr/bin/env zsh
echo $XDG_DATA_DIRS
pidof wofi && kill $(pidof wofi) || XDG_DATA_DIRS="$HOME/.local/share" wofi --show=drun --insensitive
