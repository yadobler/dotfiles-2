#!/bin/sh

# Ensure the script exits if any command fails
set -e

# Get workspace and window data from niri
WINDOWS_JSON=$(niri msg -j windows)
WORKSPACES_JSON=$(niri msg -j workspaces)

jq -nc --argjson windows "$WINDOWS_JSON" --argjson workspaces "$WORKSPACES_JSON" '
  # --- This first part for finding icons is the same ---
  ($workspaces | map(select(.is_focused)) | .[0].id) as $focused_ws_id |
  (
    $windows |
    map(select(.workspace_id == $focused_ws_id)) |
    map(.app_id |
        if contains("brave") or contains("firefox") then "󰖟"
        elif contains("ghostty") or contains("kitty") or contains("alacritty") then ""
        elif contains("thunar") or contains("nautilus") then "<span foreground=\"light yellow\"></span>"
        elif contains("telegram") then "<span foreground=\"light blue\"></span>"
        elif contains("brave-web.whatsapp.com__-Default") then "<span foreground=\"green\"></span>"
        elif contains("brave-calendar.google.com") then ""
        elif contains("brave-mail.google.com") then ""
        elif contains("brave-to-do.live.com") then ""
        elif contains("spotify") or contains("spt") or contains("Spotify Premium") then "<span foreground=\"green\"></span>"
        else "" # Default window icon
        end
    ) | 
    map(.) | if length > 0 then " " + join(" ") else "" end
  ) as $window_icons |

  # --- This final part is modified to create the desired output ---
  (
    $workspaces |
    sort_by(.idx) |
    .[0:-1] | # omit last empty workspace
    map(
      .name = (if .name == null then (.idx | tostring) else .name end) |
      if .is_focused then
        # Use Pango markup to make the active workspace bold
        .name = "<span foreground=\"light green\">[<b>" + .name + "</b></span>" + $window_icons + "<span foreground=\"light green\">]</span>"
      end
    ) | map(.name) | join("<span foreground=\"pink\"> | </span>") 
  ) as $final_text |

  # Construct the final JSON object for the custom Waybar module
  {
    "text": $final_text,
  }
'
