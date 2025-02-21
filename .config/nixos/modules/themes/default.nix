{ pkgs, colorScheme, username, ... }:
let
  colorFiles = {
    hyprland_color = pkgs.writeText "hyprland/colors.conf" (builtins.readFile "hyprland.conf");
    waybar_colors = pkgs.writeText "waybar/colors.css" (builtins.readFile "waybar.css");
    dunstrc_colors = pkgs.writeText "/dunst/dunstrc" (builtins.readFile "dunstrc");
  };
in
  {
  system.userActivationScripts.changeColors = ''
    echo ${colorFiles.waybar_colors}
  '';
}
