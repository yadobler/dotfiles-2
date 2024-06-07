{ inputs, pkgs, programs, environment, services, hardware, ... }:
{
    inputs = {
        hyprland = { 
            url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; 
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };
        iio-hyprland = { 
            url = "github:JeanSchoeller/iio-hyprland";
        };
        Hyprspace = {
            url = "github:KZDKM/Hyprspace";
            inputs.hyprland.follows = "hyprland";
        };
    };
    programs = {

        hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.system}.hyprland;
            xwayland.enable = true;
             plugins = [
                inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
                inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
             ];
# portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland.override
# {
#     inherit (pkgs) mesa;
# };
        };

        hyprlock.enable = true;
# programs.dconf.enable = true;

    };
    environment = { 
        sessionVariables = {
            NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland
            MOZ_ENABLE_WAYLAND = "1"; # ensure enable wayland for Firefox
            WLR_RENDERER_ALLOW_SOFTWARE = "1"; # enable software rendering for wlroots
            WLR_NO_HARDWARE_CURSORS = "1"; # disable hardware cursors for wlroots
            NIXOS_XDG_OPEN_USE_PORTAL = "1"; # needed to open apps after web login
        };
        systemPackages = with pkgs; [
            inputs.iio-hyprland.packages.${pkgs.system}.default
            # hyprcursor
        ];
    }

    services = {
        hypridle.enable = true;
# dbus = {
#     enable = true;
#     packages = with pkgs; [
#         gcr 
#         dconf 
#     ];
# };
    };


# xdg = {
#     portal = {
#         enable = true;
#         extraPortals = with pkgs; [
#             xdg-desktop-portal-gtk
#         ];
#         configPackages = [
#             pkgs.xdg-desktop-portal-gtk
#         ];
#     };
# };

    hardware = {
        opengl =
         {
             enable = true;
             driSupport = true;
             driSupport32Bit = true;
# package = pkgs.mesa.drivers;
# package32 = pkgs.pkgsi686Linux.mesa.drivers;
        };
    };
}
