#! /usr/bin/env zsh

ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.["id"]')
ACTIVE_WINDOW=$(hyprctl clients -j | jq -r --arg ACTIVE_WORKSPACE $ACTIVE_WORKSPACE '.[] | select(.floating == true) | select(.workspace.id | tostring | contains($ACTIVE_WORKSPACE)) | .address')
HIDDEN_WINDOW=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id < 0) | select(.pid > 0) | {key: .focusHistoryID, value:.address}' | jq -sr 'sort|reverse|.[0].value')


[[ -n "$ACTIVE_WINDOW" ]] && 
    hyprctl dispatch movetoworkspacesilent special:$SCRATCHPAD_NAME,address:$ACTIVE_WINDOW ||
    hyprctl --batch "\
        dispatch movetoworkspacesilent $ACTIVE_WORKSPACE,address:$HIDDEN_WINDOW;\
        dispatch focuswindow address:$HIDDEN_WINDOW"
