{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;  
      desktopManager.gnome.enable = true; 
      displayManager.gdm = {
        enable = true;  
        wayland = true; 
      };
    };
    
    gnome = {
      core-utilities.enable = false;
      core-os-services.enable = true;
    };

    power-profiles-daemon.enable = false;

  };

  programs = {
    xwayland.enable = true;
    evolution = {
      enable = true;
      plugins = with pkgs; [
        evolution-ews
      ];
    };
  };

  environment = { 
    systemPackages = with pkgs; [
      banana-cursor
      adwaita-icon-theme
      morewaita-icon-theme
      gruvbox-gtk-theme


      evince
      file-roller
      glib
      gnome-bluetooth
      gnome-calculator
      gnome-calendar
      gnome-clocks
      gnome-control-center
      gnome-font-viewer
      gnome-menus
      gnome-shell-extensions
      gnome-system-monitor
      gnome-tweaks
      gnome-weather
      gtk3.out
      loupe
      # nixos-background-info
      seahorse
      snapshot
      xdg-user-dirs
      xdg-user-dirs-gtk

      gnomeExtensions.kimpanel
      gnomeExtensions.caffeine
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.touch-x
    ];
  };
}
