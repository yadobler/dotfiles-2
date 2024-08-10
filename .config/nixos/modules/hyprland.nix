{ lib, inputs, pkgs, ... }:
let
  plugin-paths = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      inputs.hyprgrass.packages.${pkgs.system}.default
      #inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
  ];
  plugin-script = builtins.concatStringsSep "\n" (map (path: "hyprctl plugins load ${path}/lib/*.so") plugin-paths);
  hyprland-plugin-script = pkgs.writeScriptBin "hyprland-plugin-script.sh" ''
    #!/usr/bin/env /bin/sh
    ${plugin-script}
  '';
  username = "yukna";
in
{
    options.hyprland.postInstallScript = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Post-install script for hyprland";
    };
    config = {
        hyprland.postInstallScript = ''
            cp -f ${hyprland-plugin-script}/bin/hyprland-plugin-script.sh /home/${username}/.config/scripts/hyprland-plugin-script.sh
            chown ${username} /home/${username}/.config/scripts/hyprland-plugin-script.sh
            chmod +x /home/${username}/.config/scripts/hyprland-plugin-script.sh
            '';

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
            sessionVariables = {
                NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland
                MOZ_ENABLE_WAYLAND = "1"; # ensure enable wayland for Firefox
                WLR_RENDERER_ALLOW_SOFTWARE = "1"; # enable software rendering for wlroots
                WLR_NO_HARDWARE_CURSORS = "1"; # disable hardware cursors for wlroots
                NIXOS_XDG_OPEN_USE_PORTAL = "1"; # needed to open apps after web login
                GTK_THEME="Adwaita:dark";
            };
            systemPackages = with pkgs; [
                inputs.iio-hyprland.packages.${pkgs.system}.default
                iio-sensor-proxy
                unstable.hyprlock
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
            opengl =
            {
                enable = true;
                driSupport = true;
                driSupport32Bit = true;
                package = pkgs.mesa.drivers;
                package32 = pkgs.pkgsi686Linux.mesa.drivers;
            };
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
    };
}
