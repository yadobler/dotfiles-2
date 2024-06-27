#/usr/bin/env bash
[[ $(hyprctl clients -j | jq ".[].class | select(.==\"$1\")" | wc --lines) -eq 0 ]] && $2
