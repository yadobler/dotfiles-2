{ pkgs, lib, config, username, colorScheme, ... }:
# Bless chat gpt
let
  # List of color configuration files
  colorFiles = [
    { name = "hyprland"; src = ./hyprland.conf; target = "hypr/colors.conf"; }
    { name = "waybar"; src = ./waybar.css; target = "waybar/colors.css"; }
    { name = "dunst"; src = ./dunstrc; target = "dunst/dunstrc"; }
    { name = "wofi"; src = ./wofi.css; target = "wofi/colors.css"; }
  ];

  # Generate attribute set and symlink commands in one go
  colorFilesAttrSet = lib.listToAttrs (map (file: {
    name = file.target;
    value = pkgs.substituteAll ({ src = file.src; } // colorScheme.palette);
  }) colorFiles);

  # Generate activation script that symlinks files
  activationScript = lib.concatStringsSep "\n" (lib.attrsets.mapAttrsToList (target: path:
    "ln -sf ${path} /home/${username}/.config/${target}"
  ) colorFilesAttrSet);

in
{
  system.activationScripts.colorConfigs.text = activationScript;
}
