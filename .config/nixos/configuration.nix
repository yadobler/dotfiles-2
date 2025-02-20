{ lib, pkgs, username, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
  ];

  # limit journald log size
  services.journald.extraConfig = "SystemMaxUse=1G";

  # Power mpowerManagement
  services.upower.enable = true;
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
      START_CHARGE_THRESH_BAT1 = 90;
      STOP_CHARGE_THRESH_BAT1 = 99;
    };
  };

  # Bootloader
  swapDevices = [ { device = "/dev/disk/by-partlabel/swap"; } ];
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
        timeoutStyle = "menu";
        configurationLimit = 10;
      };
    };
  };

  # Filesystem
  fileSystems = {
    "/home" = {
      device = "/dev/nvme0n1p4";
      fsType = "ext4";
    };
  };

  # SSD
  services.fstrim.enable = lib.mkDefault true;

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
    wireplumber = {
      enable = true;
      extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
        };
      }; 
    };
  };

  # Orientation Sensor
  hardware.sensor.iio.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # i18n and keyboard
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
  users.users.${username} = {
    isNormalUser = true;
    description = "Yadobler";
    home = "/home/${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "bluetooth"
      "dialout"
    ];
  };
  # services.getty.autologinUser = ${username};

  systemd = {
    # faster boot
    services.NetworkManager-wait-online.enable = false;
  };

  # hyprland cache
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # auto delete old boot images
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 4w";
    };
  };

  system = {
    autoUpgrade.enable = false;
    stateVersion = "24.05"; # very first version used in this system
  };
}
