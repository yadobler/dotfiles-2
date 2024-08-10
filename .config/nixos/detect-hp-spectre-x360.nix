{ pkgs, lib, ... }:
let
  webcamName="Intel MIPI Camera";
  ivsc-firmware = with pkgs;
    stdenv.mkDerivation {
      pname = "ivsc-firmware";
      version = "main";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ivsc-firmware";
        rev = "10c214fea5560060d387fbd2fb8a1af329cb6232";
        sha256 = "sha256-kEoA0yeGXuuB+jlMIhNm+SBljH+Ru7zt3PzGb+EPBPw=";

      };

      installPhase = ''
        mkdir -p $out/lib/firmware/vsc/soc_a1_prod

        cp firmware/ivsc_pkg_hi556_0.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_pkg_hi556_0_a1_prod.bin
        cp firmware/ivsc_skucfg_hi556_0_1.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_skucfg_hi556_0_1_a1_prod.bin
        cp firmware/ivsc_fw.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_fw_a1_prod.bin
      '';
    };
    ipu6ep-camera-hal = with pkgs;
      stdenv.mkDerivation {
        pname = "ipu6ep-camera-hal";
        version = "main";

        src = fetchFromGitHub {
          owner = "intel";
          repo = "ipu6-camera-hal";
          rev = "8863bda8b15bef415f112700d0fb04e00a48dbee";
          sha256 = "sha256-hIdo2b8UXXfnWIGMc4MtSb9puhRdnmk+hHs3Ah9UJs8=";
        };

        nativeBuildInputs = [
          cmake
          pkg-config
        ];

        PKG_CONFIG_PATH = "${lib.makeLibraryPath [ ipu6-camera-bins ]}/ipu_adl/pkgconfig";

        cmakeFlags = [
          "-DIPU_VER=ipu6ep"
          "-DUSE_PG_LITE_PIPE=ON"
        ];

        NIX_CFLAGS_COMPILE = [
          "-Wno-error"
        ];

        enableParallelBuilding = true;

        buildInputs = [
          expat
          ipu6-camera-bins
          libtool
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
        ];

        preConfigurePhase = ''
          sed -i "s/hi556-uf-1/hi556-uf-1,hi556-uf-3/g" config/linux/ipu6ep/libcamhal_profile.xml
        '';

        postPatch = ''
          substituteInPlace src/platformdata/PlatformData.h \
          --replace '/usr/share/' "${placeholder "out"}/share/"
          '';

        postFixup = ''
          for lib in $out/lib/*.so; do
          patchelf --add-rpath "${lib.makeLibraryPath [ ipu6-camera-bins ]}/ipu_adl" $lib
          done
        '';

        };
in
{
  environment.systemPackages = [
    ipu6ep-camera-hal
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.icamerasrc-ipu6ep
    pkgs.v4l-utils
  ];
  hardware.firmware = [
    ivsc-firmware
  ];
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };
 systemd.services.v4l2-relayd = {
    environment = {
      GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [icamerasrc-ipu6ep gstreamer gst-plugins-base gst-plugins-good]);
      LD_LIBRARY_PATH = "${pkgs.ipu6-camera-bin}/lib";
    };
    script = ''
      export GST_DEBUG=2
      export DEVICE=$(grep -l -m1 -E "^${webcamName}$" /sys/devices/virtual/video4linux/*/name | cut -d/ -f6);
      exec ${pkgs.v4l2-relayd}/bin/v4l2-relayd \
        --debug \
        -i "icamerasrc" \
        -o "appsrc name=appsrc caps=video/x-raw,format=NV12,width=1280,height=720,framerate=30/1 ! videoconvert ! video/x-raw,format=YUY2 ! v4l2sink name=v4l2sink device=/dev/$DEVICE"
    '';
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "root";
      Group = "root";
    };
  };
 #  services.v4l2-relayd.instances = {
 #    ipu6 = {
 #      enable = true;
 #      cardLabel = "Intel MIPI Camera";
 #      input = {
 #        format = "NV12";
 #        pipeline = "icamerasrc";
 #      };
 #    };
 #  };

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


