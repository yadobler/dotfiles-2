{ inputs, pkgs, username, ... }:
let
  plugin-paths = [
    inputs.hyprgrass.packages.${pkgs.system}.default
  ];
in
  {
  config = {
    # hyprland cache
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      auto-optimise-store = true;
    };

    programs = {
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland.enable = true;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland.override
          {
            inherit (pkgs) mesa;
          };
      };
      dconf.enable = true;

    };

    environment = { 
      sessionVariables = {};
      systemPackages = with pkgs; [
        inputs.iio-hyprland.packages.${pkgs.system}.default
        iio-sensor-proxy
        hyprlock
        hyprcursor
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


    hardware = {
      graphics =
        {
          enable = true;
          package = pkgs.mesa.drivers;
          package32 = pkgs.pkgsi686Linux.mesa.drivers;
        };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };
  };
}
