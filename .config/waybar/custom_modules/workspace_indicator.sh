#!/bin/sh

# Ensure the script exits if any command fails
set -e

# Get workspace and window data from niri
WINDOWS_JSON=$(niri msg -j windows)
WORKSPACES_JSON=$(niri msg -j workspaces)

# Use jq to process the data and output a single JSON object for Waybar
jq -nc --argjson windows "$WINDOWS_JSON" --argjson workspaces "$WORKSPACES_JSON" '
  # --- This first part for finding icons is the same ---
  ($workspaces | map(select(.is_focused)) | .[0].id) as $focused_ws_id |
  (
    $windows |
    map(select(.workspace_id == $focused_ws_id)) |
    map(.app_id |
        if contains("brave") or contains("firefox") then "󰖟"
        elif contains("ghostty") or contains("kitty") or contains("alacritty") then ""
        elif contains("thunar") or contains("nautilus") then ""
        elif contains("telegram") then ""
        elif contains("brave-web.whatsapp.com") then ""
        elif contains("brave-calendar.google.com") then ""
        elif contains("brave-mail.google.com") then ""
        elif contains("brave-to-do.live.com") then ""
        elif contains("spotify") or contains("spt") or contains("Spotify Premium") then ""
        else "" # Default window icon
        end
    ) | if length > 0 then " " + join(" ") else "" end
  ) as $window_icons |

  # --- This final part is modified to create the desired output ---
  (
    $workspaces |
    sort_by(.idx) |
    map(
      .name = (if .name == null then (.idx | tostring) else .name end) |
      if .is_focused then
        # Use Pango markup to make the active workspace bold
        .name = "<b>" + .name + $window_icons + "</b>"
      end
    ) | map(.name) | join("  ")
  ) as $final_text |

  # Construct the final JSON object for the custom Waybar module
  {
    "text": $final_text,
    "class": "active"
  }
'
