#! /bin/zsh

ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.["id"]')
HIDDEN_WINDOWS=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id < 0) | select(.pid > 0) | .address')
hyprctl dispatch movetoworkspace $ACTIVE_WORKSPACE,address:$(echo ${HIDDEN_WINDOWS} | head -n1)
