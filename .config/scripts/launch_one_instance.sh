#!/usr/bin/env bash
ADDRESS=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$1\") | .address")
ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.["id"]')
# echo $([[ -z "$ADDRESS" ]] && echo yes) "$ACTIVE_WORKSPACE"

if [[ -z "$ADDRESS" ]]; then 
    $2 
else 
    hyprctl --batch "\
        dispatch movetoworkspacesilent $ACTIVE_WORKSPACE,address:$ADDRESS;\
        dispatch focuswindow address:$ADDRESS;\
        dispatch centerwindow"
fi
