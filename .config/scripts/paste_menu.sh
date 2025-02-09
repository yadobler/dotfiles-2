#!/usr/bin/env /bin/sh
cliphist list | wofi -i --dmenu --prompt "Clipboard History" --cache /dev/null | cliphist decode | wl-copy
