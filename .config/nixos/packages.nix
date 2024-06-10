{ pkgs, input, ... }: {
    imports = [
        ./modules/hyprland.nix
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
    };

# List packages installed in system profile.
    environment.systemPackages = with pkgs; [
        bat
            file
            lsd
            fd
            ripgrep

            neofetch
            pstree
            tree
            unzip
            wget

            gcc
            gh
            stow

            brave
            foot
            telegram-desktop

            ffmpeg
            libnotify
            pamixer
            pipewire
            pulseaudio

            dunst
            grim
            slurp
            swappy
            swayimg
            wbg
            wl-clipboard
            cliphist
            wofi
            lxqt.lxqt-policykit
            iio-sensor-proxy
            squeekboard

            flavours
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
