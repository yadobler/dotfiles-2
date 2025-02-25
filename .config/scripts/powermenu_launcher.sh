#!/usr/bin/env /bin/sh

show_powermenu() {
    choice=$(printf "󰤄 Hibernate\n⏼ Shutdown\n Reboot\n Lock" | wofi --style ~/.config/wofi/style.css --dmenu -i --height 320 -O default)
    case ${choice:2} in
        Hibernate)
            pw-play ~/.config/scripts/assets/winxpshutdown.wav &
            hyprlock &
            disown
            sleep 2
            systemctl hibernate
            ;;
        Shutdown)
            pw-play ~/.config/scripts/assets/winxpshutdown.wav &
            shutdown now
            ;;
        Reboot)
            pw-play ~/.config/scripts/assets/winxpshutdown.wav &
            systemctl reboot
            ;;
        Lock)
            pw-play ~/.config/scripts/assets/winxpshutdown.wav &
            hyprlock &
            disown
            ;;
        *)
            ;;
    esac
}

pidof wofi && kill $(pidof wofi) || show_powermenu

