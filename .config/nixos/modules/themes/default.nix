{ pkgs, lib, username, colorScheme, ... }:
# Bless chat gpt
let
  # List of color configuration files
  colorFiles = [
    { name = "hyprland"; src = ./templates/hyprland.conf; target = "hypr/colors.conf"; }
    { name = "waybar"; src = ./templates/waybar.css; target = "waybar/colors.css"; }
    { name = "dunst"; src = ./templates/dunstrc; target = "dunst/dunstrc"; }
    { name = "wofi"; src = ./templates/wofi.css; target = "wofi/colors.css"; }
    { name = "ghostty"; src = ./templates/ghostty.config; target = "ghostty/colors"; }
    { name = "fish"; src = ./templates/fish.theme; target = "fish/themes/base16.theme"; }
    { name = "nvim"; src = ./templates/nvim.lua; target = "nvim/themes/base16.lua"; }
    { name = "bat"; src = ./templates/bat.tmTheme; target = "bat/themes/base16.tmTheme"; }
  ];

  # Generate attribute set and symlink commands in one go
  colorFilesAttrSet = lib.listToAttrs (map (file: {
    name = file.target;
    value = pkgs.substituteAll ({ src = file.src; slug = colorScheme.slug; } // colorScheme.palette);
  }) colorFiles);

  # Generate activation script that symlinks files
  activationScript = lib.concatStringsSep "\n" (lib.attrsets.mapAttrsToList (target: path:
    "ln -sf ${path} /home/${username}/.config/${target}"
  ) colorFilesAttrSet);


  #gtkThemeFromScheme = import ./gtk-theme.nix { inherit pkgs; };
  #gtk-theme = gtkThemeFromScheme { scheme = colorScheme; };
  gtk-theme = pkgs.whitesur-gtk-theme;
  gtk-icon = pkgs.whitesur-icon-theme;
in
  {
  system.activationScripts.colorConfigs.text = ''
    if [ -z \"$SCRATCHPAD_NAME\" ]; then
      echo SCRATCHPAD_NAME not set, skipping theme setup...
      exit 0
    else 
      echo setting up theme ${colorScheme.slug} ...
      ln -fs ${gtk-theme}/share/themes/* /home/${username}/.themes
      ln -fs ${gtk-icon}/share/icons/* /home/${username}/.icons
    fi
  '' + activationScript + ''
    '';

}
