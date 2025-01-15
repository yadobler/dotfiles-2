#!/usr/bin/env /bin/sh
echo "{\"text\": \"dunst\", \"tooltip\": \"none\", \"class\": \"none\", \"alt\": \"$([[ $(dunstctl count waiting) -eq 0 ]] && echo none || echo notification)-$(dunstctl is-paused)\"}"

