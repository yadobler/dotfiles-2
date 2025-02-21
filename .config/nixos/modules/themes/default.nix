{ pkgs, colorScheme, lib, username, ... }:
let
  colorFiles = {
    hyprland_color  =  pkgs.substituteAll ({ src = ./hyprland.conf; } // colorScheme.palette);
    waybar_colors   =  pkgs.substituteAll ({ src = ./waybar.css; } // colorScheme.palette);
    dunstrc_colors  =  pkgs.substituteAll ({ src = ./dunstrc; } // colorScheme.palette);
  };
in
  {
  system.activationScripts.changeColors = ''
    echo ${colorFiles.waybar_colors}
  '';
}
