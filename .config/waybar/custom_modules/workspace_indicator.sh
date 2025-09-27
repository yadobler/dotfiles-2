#!/bin/sh

# Ensure the script exits if any command fails
set -e

# Get workspace and window data from niri
WINDOWS_JSON=$(niri msg -j windows)
WORKSPACES_JSON=$(niri msg -j workspaces)

jq -nc --argjson windows "$WINDOWS_JSON" --argjson workspaces "$WORKSPACES_JSON" '
  # Find the focused workspace ID
  ($workspaces | map(select(.is_focused)) | .[0].id) as $focused_ws_id |

  # Generate icons for windows on the focused workspace, highlighting the focused window
  (
    $windows |
    map(select(.workspace_id == $focused_ws_id)) |
    sort_by(.id) | # Sort the windows by their ID
    map(
      # First, determine the correct icon for the app and store it in a variable
      (.app_id |
          if contains("ghostty") or contains("kitty") or contains("alacritty") then ""
          elif contains("thunar") or contains("nautilus") then "<span foreground=\"light yellow\"></span>"
          elif contains("telegram") then "<span foreground=\"light blue\"></span>"
          elif contains("brave-web.whatsapp.com__-Default") then "<span foreground=\"green\"></span>"
          elif contains("brave-calendar.google.com") then ""
          elif contains("brave-mail.google.com") then ""
          elif contains("brave-to-do.live.com") then ""
          elif contains("spotify") or contains("spt") or contains("Spotify Premium") then "<span foreground=\"green\"></span>"
          elif contains("brave") or contains("firefox") then "󰖟"
          else "" # Default window icon
          end
      ) as $icon |

      # Now, check if this window is focused. If it is, wrap its icon with the highlight span.
      if .is_focused then
        "<span foreground=\"light green\">" + $icon + "</span>"
      else
        $icon
      end
    ) |
    # Join the icons and add a leading space if there are any
    if length > 0 then " " + join(" ") else "" end
  ) as $window_icons |

  # --- This final part is the same as your original script ---
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
    "text": $final_text
  }
'
