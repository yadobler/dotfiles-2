#! /usr/bin/zsh
paplay ~/.config/qtile/oxp.wav &

mate-polkit &
xscreensaver -no-splash &
ibus-daemon -drxR &
input-remapper-control --command autoload &
picom -b &
batsignal -c 10 -w 30 &
libinput-gestures-setup start &

~/install_dina.sh &
nitrogen --restore &

blueman-applet &
bluetoothctl power off &
nm-applet &
pasystray -m 100 &
# spicetify backup apply &

open ~/.config/autostart/*.desktop

~/.config/qtile/delay_refresh.sh &
