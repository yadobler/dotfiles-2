{ username, pkgs, lib, inputs, system, ... }:
let
  pluginScript = "/home/${username}/.config/scripts/hyprland-plugin-script_2.sh";
  pluginList = with pkgs; [
    # hyprlandPlugins.hyprfocus
    # hyprlandPlugins.hycov
    # hyprlandPlugins.hyprbars
    hyprlandPlugins.hyprgrass
    hyprlandPlugins.hyprtrails
    hyprlandPlugins.hyprscrolling
    # stable.hyprlandPlugins.hyprspace
    # hyprlandPlugins.hyprexpo
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
      hyprpicker
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
      playerctl
      wofi
      # stable.gbar
      # inputs.ignis.packages.${system}.default
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
    package = pkgs.mesa;
    package32 = pkgs.pkgsi686Linux.mesa;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  system.userActivationScripts.postInstallHyprland = lib.foldr (plugin: script: script + ''echo "hyprctl plugins load ${plugin}/lib/*.so" >> ${pluginScript}
  '') ''
    rm ${pluginScript}
    echo "#!/usr/bin/env /bin/sh" > ${pluginScript}
    chmod +x ${pluginScript}
    '' pluginList;

}
