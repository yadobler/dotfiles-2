{ config, lib, pkgs, ... }:

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

# let
#   ivsc-firmware = with pkgs;
#     stdenv.mkDerivation rec {
#       pname = "ivsc-firmware";
#       version = "main";
# 
#       src = pkgs.fetchFromGitHub {
#         owner = "intel";
#         repo = "ivsc-firmware";
#         rev = "10c214fea5560060d387fbd2fb8a1af329cb6232";
#         sha256 = "sha256-kEoA0yeGXuuB+jlMIhNm+SBljH+Ru7zt3PzGb+EPBPw=";
# 
#       };
# 
#       installPhase = ''
#         mkdir -p $out/lib/firmware/vsc/soc_a1_prod
# 
#         cp firmware/ivsc_pkg_ovti01a0_0.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_pkg_ovti01a0_0_a1_prod.bin
#         cp firmware/ivsc_skucfg_ovti01a0_0_1.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_skucfg_ovti01a0_0_1_a1_prod.bin
#         cp firmware/ivsc_fw.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_fw_a1_prod.bin
#       '';
#     };
# in
{
  # environment.systemPackages = with pkgs; [
  #   v4l-utils
  #   gst_all_1.gstreamer
  #   gst_all_1.gst-plugins-base
  #   gst_all_1.gst-plugins-good
  #   gst_all_1.gst-plugins-bad
  #   gst_all_1.icamerasrc-ipu6ep
  # ];

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  hardware.firmware = with pkgs; [
    ivsc-firmware
  ];

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

  # These rules must be understood like a script executed sequentially for
  # all devices. Instead of creating conditions, they use the old fashion
  # goto mechanism to skip some rules tu apply using goto and label
  # The first parts of each line is like a conditiong and the second part
  # describes what to run in that case.
  # To see the properties of a device, just run something like
  # udevadm info -q all -a /dev/video9
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


