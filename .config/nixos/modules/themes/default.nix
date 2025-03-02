{ pkgs, lib, username, colorScheme, nix-colors, ... }:
# Bless chat gpt
let
  # List of color configuration files
  colorFiles = [
    { name = "hyprland"; src = ./templates/hyprland.conf; target = "hypr/colors.conf"; }
    { name = "waybar"; src = ./templates/waybar.css; target = "waybar/colors.css"; }
    { name = "dunst"; src = ./templates/dunstrc; target = "dunst/dunstrc"; }
    { name = "wofi"; src = ./templates/wofi.css; target = "wofi/colors.css"; }
    { name = "ghostty"; src = ./templates/ghostty.config; target = "ghostty/colors"; }
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


  # gtkThemeFromScheme = import ./gtk-theme.nix { inherit pkgs; };
  # gtk-theme = gtkThemeFromScheme { scheme = colorScheme; };
in
  {
  system.activationScripts.colorConfigs.text = ''
    echo $tty
  '' + activationScript + ''
    '';
  # rm /home/${username}/.themes/generated 
  # ln -s "${gtk-theme}/share/themes/${colorScheme.slug}/" /home/${username}/.themes/generated 
}
