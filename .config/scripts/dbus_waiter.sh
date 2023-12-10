#! /bin/bash
while ! dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep org.kde.StatusNotifierWatcher; 
do sleep 0.1; 
done

telegram-desktop -autostart &
disown
exit
