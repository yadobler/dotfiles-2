#!/usr/bin/env /bin/sh
ADDRESS=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$1\") | .address")
ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.["id"]')
echo "$ADDRESS" "$ACTIVE_WORKSPACE"
exit
[[ $(echo "$ADDRESS" | wc --lines) -le 1 ]] && echo new || echo switch
[[ $(echo "$ADDRESS" | wc --lines) -le 1 ]] && $1 || hyprctl --batch "\
        dispatch movetoworkspacesilent $ACTIVE_WORKSPACE,address:$ADDRESS;\
        dispatch focuswindow address:$ADDRESS;\
        dispatch centerwindow"
