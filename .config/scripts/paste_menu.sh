#! /usr/bin/env zsh
cliphist list | wofi -i -G --dmenu --prompt "Clipboard History" --cache /dev/null | cliphist decode | wl-copy

