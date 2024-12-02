{ pkgs, ... }:
{
    imports = [
        ./modules/hyprland.nix
        ./modules/gnome_polkit.nix
        ./modules/terminal.nix
        ./modules/thunar.nix
        ./modules/nvim.nix
        #./modules/obs.nix
        #./modules/nemo.nix
    ];
# Allow unfree packages
    nixpkgs.config.allowUnfree = true;

# programmes
    programs = {
        git.enable = true;
        light.enable = true;
        waybar.enable = true;
        xwayland.enable = true;
        nm-applet.enable = true;
        file-roller.enable = true;
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
            gleam
 
            brave
            telegram-desktop
            zathura
            xournalpp
            swayimg
            clapper
            spotify

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
            wf-recorder
            swappy
            wbg
            wl-clipboard
            cliphist
            wofi
            iio-sensor-proxy
            squeekboard
            playerctl
            glow

            wallust
            adwaita-icon-theme
            adwaita-qt
            morewaita-icon-theme
            gnome-tweaks
            banana-cursor

            jetbrains.idea-community
            arduino
            scenebuilder
            obsidian
            gdb
            p7zip
            binwalk
            pandoc
            texliveFull
            binwalk
            
            
    ];

# Font
    fonts = {
        fontDir.enable = true;
        packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-emoji
            fira-code
            fira-math
            fira-code-symbols
            (nerdfonts.override { 
                fonts = [ 
                    "FiraCode" 
                ]; 
            })
        ];
        fontconfig = {
            defaultFonts = {
                serif = [ "Noto Serif" ];
                sansSerif = [ "Noto Sans" ];
                monospace = [ "FiraCode Nerd Font Mono" ];
                emoji = [ "Noto Color Emoji" ];

            };
        };
    };
}
