{ username, pkgs, lib, ... }:
let
  pluginScript = "/home/${username}/.config/scripts/hyprland-plugin-script_2.sh";
  pluginList = [
      # hyprlandPlugins.hyprfocus
      pkgs.hyprlandPlugins.hyprgrass
      pkgs.hyprlandPlugins.hyprspace
  ];
in
{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    dconf.enable = true;
    iio-hyprland.enable = true;
    waybar.enable = true;
    xwayland.enable = true;
  };

  environment = { 
    systemPackages = with pkgs; [
      hyprlock
      hyprcursor
      banana-cursor
      swaybg
      
      pamixer
      pavucontrol
      dunst
      grim
      slurp
      wf-recorder
      swappy
      wl-clipboard
      cliphist
      wofi
      squeekboard
      playerctl
    ];
  };

  services = {
    hypridle.enable = true;
    dbus = {
      enable = true;
      packages = with pkgs; [
        gcr
        dconf
      ];
    };
  };


  hardware.graphics = {
    enable = true;
    package = pkgs.mesa.drivers;
    package32 = pkgs.pkgsi686Linux.mesa.drivers;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  system.activationScripts.postInstallHyprland = lib.foldr (plugin: script: script + ''echo "hyprctl plugins load ${plugin}/lib/*.so" >> ${pluginScript}
  '') ''
    rm ${pluginScript}
    echo "#!/usr/bin/env /bin/sh" > ${pluginScript}
    chmod +x ${pluginScript}
    '' pluginList;

}
