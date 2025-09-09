{ username, pkgs, ... }:
{
  imports = [
  ];

  programs = {
    niri = { 
      enable = true; 
    }; 
    dconf = { 
      enable = true; 
    }; 
    hyprlock = { 
      enable = true; 
    }; 
    # xwayland = { 
    # enable = true; 
    # };
  };

  environment = { 
    systemPackages = with pkgs; [
      waybar  # avoid automatic systemd startup
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
    hypridle = { 
      enable = true; 
    }; 
    dbus = {
      enable = true;
      packages = with pkgs; [
        gcr
        dconf
        # gnome-keyring
      ];
    };
    # gnome.gnome-keyring = {
    #   enable = true;
    # };
  };

  # systemd.services."getty@tty1" = {
  #   overrideStrategy = "asDropin";
  #   serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login --autologin ${username} --noclear --keep-baud %I 115200,38400,9600 $TERM"];
  # };
  # security.pam.services = {
  #   hyprlock.enableGnomeKeyring = true;
  #   login.enableGnomeKeyring = true;
  # };


  hardware.graphics = {
    enable = true;
    package = pkgs.mesa;
    package32 = pkgs.pkgsi686Linux.mesa;
  };

  xdg.portal = {
    enable = true;
    wlr = { 
      enable = true; 
    }; 
    configPackages = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
