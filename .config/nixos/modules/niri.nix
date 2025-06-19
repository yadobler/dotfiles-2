{ username, pkgs, lib, inputs, system, ... }:
{
  programs = {
    niri.enable = true;
    dconf.enable = true;
    iio-hyprland.enable = true;
    waybar.enable = true;
    xwayland.enable = true;
  };

  environment = { 
    systemPackages = with pkgs; [
      banana-cursor
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
