{ lib, config, pkgs, ... }:
{
    imports = [ 
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

    # Power mpowerManagement
    services.logind.lidSwitch = "lock";
    services.tlp = {
        enable = true;
        settings = {
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

            CPU_MIN_PERF_ON_AC = 0;
            CPU_MAX_PERF_ON_AC = 100;
            CPU_MIN_PERF_ON_BAT = 0;
            CPU_MAX_PERF_ON_BAT = 80;

            #Optional helps save long term battery health
            START_CHARGE_THRESH_BAT0 = 90;
            STOP_CHARGE_THRESH_BAT0 = 99; 
        };
    };

    # Bootloader
    swapDevices = [{device = "/dev/disk/by-partlabel/swap";}];
    boot = {
        resumeDevice = "/dev/disk/by-partlabel/swap";
        kernelParams = [
            "resume=PARTLABEL=swap"
            "mem_sleep_default=deep"
            "splash"
            "quiet"
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
        networkmanager = {
            enable = true;
        };
    };
    programs.nm-applet.enable = true;

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

    i18n = {
        defaultLocale = "en_SG.UTF-8";
        inputMethod = {
            enable = true;
            type = "fcitx5";
            fcitx5 = {
                waylandFrontend = false;
                addons = with pkgs; [
                    fcitx5-with-addons
                    fcitx5-gtk
                    fcitx5-m17n
                    fcitx5-bamboo
                    fcitx5-table-extra
                    fcitx5-material-color
                    libsForQt5.fcitx5-chinese-addons
                ];
            };
        };
        extraLocaleSettings = {
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
    };

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # touchpad
    services.libinput = {
        enable = true;
        touchpad = {
            tappingDragLock = true;
            tappingButtonMap = "lrm";
            tapping = "true";
            scrollMethod = "twofinger";
            naturalScrolling = false;
            middleEmulation = true;
            leftHanded = false;
            horizontalScrolling = true;
            disableWhileTyping = true;
            accelProfile = "flat";
        };
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
            "dialout"
        ];
    };
    # services.getty.autologinUser = "yukna";

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
