{ inputs, pkgs, programs, environment, services, hardware, ... }:
{
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
        hyprlock.enable = true;
        dconf.enable = true;

    };

    environment = { 
        sessionVariables = {
            NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland
            MOZ_ENABLE_WAYLAND = "1"; # ensure enable wayland for Firefox
            WLR_RENDERER_ALLOW_SOFTWARE = "1"; # enable software rendering for wlroots
            WLR_NO_HARDWARE_CURSORS = "1"; # disable hardware cursors for wlroots
            NIXOS_XDG_OPEN_USE_PORTAL = "1"; # needed to open apps after web login
            XDG_DATA_DIRS = "$HOME/.nix-profile/share:$HOME/.local/share:$XDG_DATA_DIRS";
        };
        systemPackages = with pkgs; [
            inputs.iio-hyprland.packages.${pkgs.system}.default
            # hyprcursor
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
        opengl =
        {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
            package = pkgs.mesa.drivers;
            package32 = pkgs.pkgsi686Linux.mesa.drivers;
        };
    };

    xdg = {
        portal = {
            enable = true;
            extraPortals = with pkgs; [
                xdg-desktop-portal-gtk
            ];
            configPackages = [
                pkgs.xdg-desktop-portal-gtk
            ];
        };
    };
}
