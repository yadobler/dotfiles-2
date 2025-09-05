{ inputs, pkgs, ... }:
{
  imports = [
  ];

  programs = {
    niri.enable = true;
    dconf.enable = true;
    hyprlock.enable = true;
    waybar.enable = true;
    # xwayland.enable = true;
  };

  environment = { 
    systemPackages = with pkgs; [
      xwayland-satellite
      iio-sensor-proxy
      banana-cursor
      pamixer
      pavucontrol
      wf-recorder
      swaybg
      wl-clipboard
      cliphist
      playerctl
      wofi
      glib
      niriswitcher
      dunst
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
      xdg-desktop-portal-gtk
    ];
  };
}
