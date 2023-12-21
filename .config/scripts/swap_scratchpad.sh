#! /bin/zsh

ACTIVE_WINDOW=$(hyprctl activewindow -j | jq -r '.address')
ACTIVE_WINDOW_FLOATING=$(hyprctl activewindow -j | jq -r '.floating')
ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.["id"]')
HIDDEN_WINDOW=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id < 0) | select(.pid > 0) | {key: .focusHistoryID, value:.address}' | jq -sr 'sort|reverse|.[0].value')
[[ "$ACTIVE_WINDOW_FLOATING" == "true" ]] && hyprctl dispatch movetoworkspacesilent special:,address:$ACTIVE_WINDOW
hyprctl dispatch movetoworkspacesilent $ACTIVE_WORKSPACE,address:$HIDDEN_WINDOW
