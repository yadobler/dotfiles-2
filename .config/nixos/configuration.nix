{ pkgs, ... }:

{
    imports = [ 
        ./hardware-configuration.nix
        # ./detect-hp-spectre-x360.nix
        ./packages.nix
    ];

    # Bootloader
    swapDevices = [{device = "/dev/disk/by-partlabel/swap";}];
    boot.resumeDevice = "/dev/disk/by-partlabel/swap";
    boot.kernelParams = [
        "resume=PARTLABEL=swap"
            "quiet"
            "splash"
    ];
    boot.loader = {
        efi.canTouchEfiVariables = true;
        grub = {
            enable = true;
            device = "nodev";
            efiSupport = true;
            gfxmodeEfi = "3000x2000";
            font = "${pkgs.unifont}/share/fonts/opentype/unifont.otf";
            fontSize = 64;
        };
    };

    # Filesystem
    fileSystems."/home" = {
        device = "/dev/nvme0n1p4";
        fsType = "ext4";
    };


    # Networking
    networking.hostName = "vellinator"; # Define your hostname.
    networking.networkmanager.enable = true;

    # Bluetooth
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
    };
    services.blueman.enable = true;

    # Sound
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    # Set your time zone.
    time.timeZone = "Asia/Singapore";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_SG.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_SG.UTF-8";
        LC_IDENTIFICATION = "en_SG.UTF-8";
        LC_MEASUREMENT = "en_SG.UTF-8";
        LC_MONETARY = "en_SG.UTF-8";
        LC_NAME = "en_SG.UTF-8";
        LC_NUMERIC = "en_SG.UTF-8";
        LC_PAPER = "en_SG.UTF-8";
        LC_TELEPHONE = "en_SG.UTF-8";
        LC_TIME = "en_SG.UTF-8";
    };

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.yukna = {
        isNormalUser = true;
        description = "Yadobler";
        home = "/home/yukna";
        extraGroups = [
            "networkmanager"
                "wheel"
                "video"
        ];
        shell = pkgs.zsh;
    };

    # Experiemtnal features
    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    system.stateVersion = "24.05"; # Did you read the comment?
}
