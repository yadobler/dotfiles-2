#! /usr/bin/sh

source ~/.cache/wal/colors.sh
swww img $wallpaper --resize=fit
swaync-client -rs
killall waybar
waybar &
disown
