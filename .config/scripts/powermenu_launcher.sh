#!/usr/bin/env /bin/sh

show_powermenu() {
    choice=$(printf "󰤄 Hibernate\n⏼ Shutdown\n Reboot\n Lock" | wofi --style $HOME/.config/wofi/style.css --dmenu -i --height 320 -O default)
    # pw-play ~/.config/scripts/assets/winxpshutdown.wav &
    case ${choice:2} in
        Hibernate)
            hyprlock &
            disown
            sleep 2
            niri msg output eDP-1 off
            systemctl hibernate
            ;;
        Shutdown)
            sleep 2
            shutdown now
            ;;
        Reboot)
            sleep 2
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

pidof wofi && kill "$(pidof wofi)" || show_powermenu

