#!/usr/bin/env /bin/sh

if [[ "$(hyprctl activewindow -j | jq -r ".class")" =~ ^(ncspot|Steam|brave-keep.google.com.+|brave-ticktick.com__webapp+|brave-open.spotify.com.+|brave-web.whatsapp.com.+|brave-mail.google.com__mail_u_.-Default|brave-calendar.google.com__calendar_u_1_r-Default)$ ]]; then
    hyprctl dispatch movetoworkspacesilent special:"$SCRATCHPAD_NAME"
else
    hyprctl dispatch killactive ""
fi

