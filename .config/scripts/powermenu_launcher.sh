#!/usr/bin/env /bin/sh

show_powermenu() {
    choice=$(printf "󰤄 Hibernate\n⏼ Shutdown\n Reboot\n Lock" | wofi --style ~/.config/wofi/style.css --dmenu -i --height 320 -O default)
    case ${choice:2} in
        Hibernate)
            hyprlock &
            disown
            sleep 2
            systemctl hibernate
            ;;
        Shutdown)
            shutdown now
            ;;
        Reboot)
            systemctl reboot
            ;;
        Lock)
            hyprlock &
            disown
            ;;
        *)
            ;;
    esac
}

pidof wofi && kill $(pidof wofi) || show_powermenu

