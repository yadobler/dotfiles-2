#! /bin/zsh

if [[ "$(hyprctl activewindow -j | jq -r ".class")" =~ "^(Steam||brave-web.whatsapp.com.+|brave-mail.google.com__mail_u_.-Default|brave-calendar.google.com__calendar_u_1_r-Default)$" ]]; then
    hyprctl dispatch movetoworkspacesilent special:hidden
else
    hyprctl dispatch killactive ""
fi
