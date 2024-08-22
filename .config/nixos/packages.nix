{ pkgs, lib, ... }:
{
    imports = [
        ./modules/hyprland.nix
        ./modules/gnome_polkit.nix
        ./modules/terminal.nix
        ./modules/thunar.nix
        ./modules/nvim.nix
        #./modules/nemo.nix
    ];
# Allow unfree packages
    nixpkgs.config.allowUnfree = true;

# programmes
    programs = {
        git.enable = true;
        light.enable = true;
        zsh.enable = true;
        waybar.enable = true;
        xwayland.enable = true;
        nm-applet.enable = true;
    };

# List packages installed in system profile.
    environment.systemPackages = with pkgs; [
            bat
            file
            lsd
            fd
            ripgrep
            oh-my-posh
            bottom

            neofetch
            pstree
            tree
            unzip
            wget
            jq
            bc

            glm
            meson
            ninja
            gcc
            gh
            stow
            glib
            tree-sitter
            nodejs
            go
            zig
            cargo
            rustc
            nil # nix lsp
            poetry

            brave
            telegram-desktop
            zathura
            xournalpp
            swayimg
            clapper
            unstable.spotify

            imagemagick
            ffmpeg
            libnotify
            pamixer
            pipewire
            pulseaudio
            pavucontrol

            dunst
            grim
            slurp
            swappy
            wbg
            wl-clipboard
            cliphist
            wofi
            iio-sensor-proxy
            squeekboard
            playerctl

            wallust
            adwaita-icon-theme
            adwaita-qt
            morewaita-icon-theme
            gnome-tweaks
            banana-cursor
            ];

# Font
    fonts.packages = with pkgs; [
        noto-fonts
            noto-fonts-cjk
            noto-fonts-emoji
            fira-code
            fira-math
            fira-code-symbols
            (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
}
