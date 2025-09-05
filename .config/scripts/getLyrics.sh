#!/usr/bin/env /bin/sh
TRACKID=$(playerctl metadata --format "{{mpris:trackid}}" | awk -F/ '{ print $NF}')
FETCHURL="https://lyrix.vercel.app/getLyrics/$TRACKID"

# https://chatgpt.com/share/66e480fa-5300-800f-aac1-261f96e74b70
# Define the directory path and file path
CACHE_DIR="$HOME/.cache/spotifyLyrics"
TRACK_FILE="$CACHE_DIR/$TRACKID"

# Step 1: Create the directory if it doesn't exist
if [ ! -d "$CACHE_DIR" ]; then
    mkdir -p "$CACHE_DIR"
fi

# Step 2: Check if the track file exists, else fetch and save it
if [ ! -f "$TRACK_FILE" ]; then
    # Use curl to fetch the file from the URL
    HTTP_RESPONSE=$(curl -s -o "$TRACK_FILE" -w "%{http_code}" "$FETCHURL")
    
    # Check if the curl command was successful (no server error)
    if [ "$HTTP_RESPONSE" -ge 200 ] && [ "$HTTP_RESPONSE" -lt 300 ]; then
        echo "Track saved successfully."
    else
        echo "Failed to fetch track. Server responded with HTTP status $HTTP_RESPONSE."
        rm -f "$TRACK_FILE"  # Remove the file if it was created
    fi
else
    echo "Track already exists at $TRACK_FILE."
fi

# Lyrics color : decimal -> HEX ARGB
