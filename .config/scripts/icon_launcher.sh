#! /usr/bin/env zsh
export XDG_DATA_HOME="/home/yukna/.local/share"
pidof wofi && kill $(pidof wofi) || wofi --show drun -f --conf ~/.config/wofi/config_icon_launcher --style ~/.config/wofi/style_icon_launcher.css
