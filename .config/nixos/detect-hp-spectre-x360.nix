{ inputs, pkgs, ... }:
let
  ipu6 = inputs.ipu6-fix.packages.${pkgs.system};
in
{
    environment.systemPackages = with ipu6; [
        icamerasrc
            ipu6-camera-bins
            ipu6-camera-hal
            ipu6-drivers
            ivsc-driver
            ivsc-firmware
    ];

#let
#detectHpSpectre = pkgs.runCommand "detect-hp-spectre" {
#  buildInputs = [ pkgs.dmidecode ];
#} ''
#  productName=$(dmidecode -s system-product-name)
#  if [[ "$productName" == *"HP Spectre x360"* ]]; then
#  echo "detected=1" > $out
#  else
#  echo "detected=0" > $out
#  fi 
#  '';
#  in
#{
#  hardware.ipu6 = if hpSpectreDetected.detected == "1" then {
#    enable = true;
#    platform = "ipu6ep";
#  } else {
#    enable = false;
#    platform = null;
#  };
#}

# {
#   hardware.ipu6 = {
#     enable = true;
#     platform = "ipu6ep";
#   };
# 
#   hardware.firmware = with pkgs; [
#     ivsc-firmware
#   ];

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

  # environment.etc.camera.source = "${ipu6-camera-hal}/share/defaults/etc/camera";
}


