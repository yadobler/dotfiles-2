#!/usr/bin/env /bin/sh

# Get current notification status
count=$(dunstctl count waiting)
paused=$(dunstctl is-paused) # Returns "true" or "false"

# Determine the 'alt' key for format-icons lookup
# This logic remains the same as your original script
if [ "$count" -eq 0 ]; then
    alt_key="none"
else
    alt_key="notification"
fi
alt_key="$alt_key-$paused" # Results in none-false, notification-false, none-true, or notification-true

# Build dynamic tooltip
if [ "$paused" = "true" ]; then
    tooltip="Notifications Paused"
    if [ "$count" -gt 0 ]; then
        tooltip="$tooltip ($count waiting)"
    fi
else
    if [ "$count" -gt 0 ]; then
        tooltip="$count Waiting Notification(s)"
    else
        tooltip="No Waiting Notifications"
    fi
fi

# Build dynamic CSS class list as a JSON array fragment
# Important for CSS: adds "has-notification" if count>0, "is-paused" if paused=true
class_list=""
if [ "$count" -gt 0 ]; then
    class_list="\"has-notification\"" # Add first class
fi
if [ "$paused" = "true" ]; then
    if [ -n "$class_list" ]; then
        class_list="$class_list, \"is-paused\"" # Add second class with comma
    else
        class_list="\"is-paused\"" # Add first class
    fi
fi

# Construct and output the JSON for Waybar
# Using printf for safer handling of quotes and variables
printf '{"alt": "%s", "tooltip": "%s", "class": [%s]}\n' \
    "$alt_key" \
    "$tooltip" \
    "$class_list"

