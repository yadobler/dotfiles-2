{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.ipu6ep-camera-hal-unstable
    unstable.icamerasrc-ipu6ep-unstable
    unstable.ivsc-firmware-unstable
    v4l-utils
  ];

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  services.v4l2-relayd.instances = {
    ipu6 = {
      enable = true;
      cardLabel = "Virtual Camera";
      input = {
        format = "YUY2";
        pipeline = "icamerasrc";
      };
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM!="video4linux", GOTO="hide_cam_end"
    #ATTR{name}=="Intel MIPI Camera", GOTO="hide_cam_end"
    ATTR{name}!="Dummy video device (0x0000)", GOTO="hide_cam_end"
    ACTION=="add", RUN+="${pkgs.coreutils}/bin/mkdir -p /dev/not-for-user"
    ACTION=="add", RUN+="${pkgs.coreutils}/bin/mv -f $env{DEVNAME} /dev/not-for-user/"
    # Since we skip these rules for the mipi, we do not need to link it back to /dev
    # ACTION=="add", ATTR{name}!="Intel MIPI Camera", RUN+="${pkgs.coreutils}/bin/ln -fs $name /dev/not-for-user/$env{ID_SERIAL}"
    ACTION=="remove", RUN+="${pkgs.coreutils}/bin/rm -f /dev/not-for-user/$name"
    ACTION=="remove", RUN+="${pkgs.coreutils}/bin/rm -f /dev/not-for-user/$env{ID_SERIAL}"
    LABEL="hide_cam_end"
    '';
}


