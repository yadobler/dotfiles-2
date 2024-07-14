#! /usr/bin/env zsh

show_powermenu() {
    choice=$(printf "󰤄 Hibernate\n⏼ Shutdown\n Reboot" | wofi --dmenu -Gi --height 200)
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
        *)
            ;;
    esac
}

pidof wofi && kill $(pidof wofi) || show_powermenu

