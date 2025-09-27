#!/bin/sh

# Ensure the script exits if any command fails
set -e

# Get workspace and window data from niri
WINDOWS_JSON=$(niri msg -j windows)
WORKSPACES_JSON=$(niri msg -j workspaces)
JQ_SCRIPT="$HOME/.config/waybar/custom_modules/workspace_indicator.jq"

jq -ncf $JQ_SCRIPT --argjson windows "$WINDOWS_JSON" --argjson workspaces "$WORKSPACES_JSON"
