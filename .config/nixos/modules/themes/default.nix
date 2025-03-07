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
    { name = "fish"; src = ./templates/fish.theme; target = "fish/themes/base16.theme"; }
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


  gtkThemeFromScheme = import ./gtk-theme.nix { inherit pkgs; };
  gtk-theme = gtkThemeFromScheme { scheme = colorScheme; };
in
  {
  system.activationScripts.colorConfigs.text = ''
    if [ -z \"$__NIXOS_SET_ENVIRONMENT_DONE\" ]; then
      echo __NIXOS_SET_ENVIRONMENT_DONE not set, skipping theme setup...
      exit 0
    else 
      echo setting up theme ${colorScheme.slug} ...
      rm /home/${username}/.themes/WhiteSur* 
      ln -s ${gtk-theme}/share/themes/* /home/${username}/.themes
    fi
  '' + activationScript + ''
    '';

}
