{ username, pkgs, lib, inputs, system, ... }:
{
  programs = {
    niri.enable = true;
    dconf.enable = true;
    waybar.enable = true;
    xwayland.enable = true;
  };

  environment = { 
    systemPackages = with pkgs; [
      iio-sensor-proxy
      banana-cursor
      pamixer
      pavucontrol
      dunst
      wf-recorder
      swappy
      swaybg
      wl-clipboard
      cliphist
      playerctl
      wofi
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
