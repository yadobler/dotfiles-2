{ pkgs, ... }: {
    imports = [
        ./modules/hyprland.nix
        #./modules/thunar.nix
        ./modules/nemo.nix
        ./modules/gnome_polkit.nix
    ];
# Allow unfree packages
    nixpkgs.config.allowUnfree = true;

# programmes
    programs = {
        git.enable = true;
        light.enable = true;
        neovim.enable = true;
        waybar.enable = true;
        xwayland.enable = true;
        zsh.enable = true;
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
            nil # nix lsp

            brave
            foot
            telegram-desktop
            zathura
            swayimg
            clapper

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

            wallust
            sweet-folders
            candy-icons
            gnome.gnome-tweaks
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
