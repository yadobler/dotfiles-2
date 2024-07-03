{ lib, config, pkgs, ... }:
{
    imports = [ 
        # ./detect-hp-spectre-x360.nix
        ./hardware-configuration.nix
        ./packages.nix
    ];

    # To add additional postInstallScripts:
    # (1) add this to the submodule:
    #
    #     options.<MODULE>.postInstallScript = lib.mkOption {
    #       type = lib.types.lines;
    #       default = "";
    #       description = "Post-install script for module 1";
    #     };
    #     config = {
    #       <MODULE>.postInstallScript = ''
    #          < INSERT Post-install COMMANDS HERE >
    #         '';
    #      < REST OF CONFIG GOES HERE >
    #     };
    #
    # (2) Update below to add config.<MODULE>.postInstallScript
    #
    system.activationScripts.postInstall = lib.concatStringsSep "\n" [
        ''#!/usr/bin/env bash''
        config.terminal.postInstallScript
        config.hyprland.postInstallScript
    ];


    # Bootloader
    swapDevices = [{device = "/dev/disk/by-partlabel/swap";}];
    boot = {
        resumeDevice = "/dev/disk/by-partlabel/swap";
        kernelParams = [
            "resume=PARTLABEL=swap"
            "quiet"
            "splash"
        ];
        loader = {
            efi.canTouchEfiVariables = true;
            grub = {
                enable = true;
                device = "nodev";
                efiSupport = true;
                gfxmodeEfi = "3000x2000";
                font = "${pkgs.unifont}/share/fonts/opentype/unifont.otf";
                fontSize = 64;
                configurationLimit = 10;
            };
        };
    };

    # Filesystem
    fileSystems."/home" = {
        device = "/dev/nvme0n1p4";
        fsType = "ext4";
    };

    # Networking
    networking = {
        hostName = "vellinator"; # Define your hostname.
        networkmanager.enable = true;
    };

    # Bluetooth
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General = {
            Enable = "Source,Sink,Media,Socket";
            EnableLE = "true";
            EnableGatt = "true";
        };
    };
    services.blueman.enable = true;

    # Sound
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        pulse.enable = true;
        wireplumber.extraConfig = {
            "monitor.bluez.properties" = {
                "bluez5.enable-sbc-xq" = true;
                "bluez5.enable-msbc" = true;
                "bluez5.enable-hw-volume" = true;
                "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
            };
        };
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
            "bluetooth"
        ];
        shell = pkgs.zsh;
    };
    services.getty.autologinUser = "yukna";

    # hibernation flashing fix?

    systemd = {
        user.services."resume@" = {
            description = "User resume actions";
            after = [ "hibernate.target" ];
            wantedBy = [ "suspend.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStartPost="/usr/bin/env sleep 1";
                User="%I";
            };
        };
    };

    # Experiemtnal features
    nix = {
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
            substituters = ["https://hyprland.cachix.org"];
            trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
            auto-optimise-store = true;
        };
        gc = {
            automatic = true;
            dates = "monthly";
            options = "--delete-older-than 4w";
        };
    };
    system.autoUpgrade.enable = true;
    system.stateVersion = "24.05"; # Did you read the comment?
}
