{ pkgs, lib, ... }:
let
  ipuVersion = "ipu6ep";
  ipu6-drivers = pkgs.stdenv.mkDerivation {
    src = pkgs.fetchFromGitHub {
      sha256 = "sha256-y3oxKdcAZXSe5tjhTOX018LsDEf5kh3bkClK8TwtdOQ=";
      owner = "intel";
      repo = "ipu6-drivers";
      rev = "10e247e046086970a9427988d5a454676515e43b";
    };
  };
  ipu6-camera-bins = pkgs.stdenv.mkDerivation {
    src = pkgs.fetchFromGitHub {
      sha256 = "sha256-Vl+l43Ed2f7lL/iXG59wdrfyTrTohaYlL79+zDw805E=";
      owner = "intel";
      repo = "ipu6-camera-bins";
      rev = "9874603336d97fd4d12a271485645aaabc7c1be3";
    };
    installPhase = ''
      mkdir $out
      mv ./${ipuVersion}/include $out/include
      mv ./${ipuVersion}/lib $out/lib
      '';
  };
  ipu6ep-camera-hal = pkgs.stdenv.mkDerivation {
    src = pkgs.fetchFromGitHub {
      sha256 = "sha256-o62ce5a1gqVMccOnfw9lto32sXutZtiV2BFUNATyiww=";
      owner = "intel";
      repo = "ipu6-camera-hal";
      rev = "8bad42ce759a0bef504f03a7d1dd91510290cfeb";
    };
    NIX_CFLAGS_COMPILE = "-I${ipu6-camera-bins}/include/ia_camera -I${ipu6-camera-bins}/include/ia_cipf -I${ipu6-camera-bins}/include/ia_cipf_css -I${ipu6-camera-bins}/include/ia_imaging -I${ipu6-camera-bins}/include/ia_tools";

    nativeBuildInputs = [
      ipu6-camera-bins
      pkgs.pkg-config
    ];

    buildInputs = with pkgs; [
      expat
        automake
        cmake
        libtool
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
    ];

    propagatedBuildInputs = [
      ipu6-camera-bins
    ];

    patchPhase = ''
      # Remove slash from the end of prefix to avoid double slashes
      substituteInPlace cmake/libcamhal.pc.cmakein \
      --replace \''${prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace \''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
      '';

    preConfigurePhase = ''
      sed -i "s/hi556-uf-1/hi556-uf-1,hi556-uf-3/g" config/linux/ipu6ep/libcamhal_profile.xml
    '';
    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
        "-DIPU_VER=${ipuVersion}"
        "-DENABLE_VIRTUAL_IPU_PIPE=OFF"
        "-DUSE_PG_LITE_PIPE=ON"
        "-DUSE_STATIC_GRAPH=OFF"
    ];
  };
  icamerasrc = pkgs.stdenv.mkDerivation {
    src = pkgs.fetchFromGitHub {
      sha256 = "sha256-6kYU0KqhgJnFGANwlCwUYpk5KWgcXVLFQwp8vZIa0fQ=";
      owner = "intel";
      repo = "icamerasrc";
      rev = "3b7cdb93071360aacebb4e808ee71bb47cf90b30";
    };
    # Fix missing def
    CHROME_SLIM_CAMHAL = "ON";
    STRIP_VIRTUAL_CHANNEL_CAMHAL = "ON";

    # I think their autoconf settings assume the plugs will be in the same directory as the main gstreamer headers
    # which isn't true in Nix. I don't know autotools enough to patch it, so I'm just gonna hack this onto the end.
    CPPFLAGS = "-I${pkgs.gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

    nativeBuildInputs = with pkgs; [
      autoreconfHook
      pkg-config
      gst_all_1.gst-plugins-base.dev
    ];

    buildInputs = with pkgs; [
      libdrm
    ];

    propagatedBuildInputs = [
      ipu6ep-camera-hal
    ];
  };
  kernelSrc = "${pkgs.kernel.dev}/lib/modules/${pkgs.kernel.modDirVersion}/build";
  ivsc-driver = pkgs.stdenv.mkDerivation {
    src = pkgs.fetchFromGitHub {
      sha256 = "sha256-y3oxKdcAZXSe5tjhTOX018LsDEf5kh3bkClK8TwtdOQ=";
      owner = "intel";
      repo = "ipu6-drivers";
      rev = "10e247e046086970a9427988d5a454676515e43b";
    };

    passthru.moduleName = "ipu6";

    nativeBuildInputs = pkgs.kernel.moduleBuildDependencies;

    buildFlags = [
      "KERNEL_SRC=${kernelSrc}"
      "KERNELRELEASE=${pkgs.kernel.modDirVersion}"
    ];

    patchPhase = ''
      cp -r ${ivsc-driver}/{backport-include,drivers,include} .
      # For some reason, this copies with 555 instead of 755
      chmod -R 755 backport-include drivers include 
      '';

    installPhase = ''
      make -C ${kernelSrc} \
      M=$(pwd) \
      INSTALL_MOD_PATH=$out \
      modules_install
      cp -r include $out/
      '';
  };
  ivsc-firmware = pkgs.stdenv.mkDerivation {
    src = pkgs.fetchFromGitHub {
      sha256 = "sha256-GuD1oTnDEs0HslJjXx26DkVQIe0eS+js4UoaTDa77ME=";
      owner = "intel";
      repo = "ivsc-firmware";
      rev = "29c5eff4cdaf83e90ef2dcd2035a9cdff6343430";
    };
    installPhase = ''
      mkdir -p $out/lib/firmware/vsc/soc_a1_prod

      cp firmware/ivsc_pkg_hi556_0.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_pkg_ovti01a0_0_a1_prod.bin
      cp firmware/ivsc_skucfg_hi556_0_1.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_skucfg_ovti01a0_0_1_a1_prod.bin
      cp firmware/ivsc_fw.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_fw_a1_prod.bin
      '';
  };
in
{
  environment.systemPackages = [
    ipu6-drivers
    ipu6-camera-bins
    ipu6ep-camera-hal
    icamerasrc
    ivsc-driver
  #pkgs.gst_all_1.icamerasrc-ipu6ep
  #pkgs.gst_all_1.gstreamer
  #pkgs.gst_all_1.gst-plugins-base
  #pkgs.v4l-utils
  ];
  hardware.firmware = [ 
    ivsc-firmware
  ];

  #hardware.ipu6 = {
  #  enable = true;
  #  platform = "ipu6ep";
  #};
  services.v4l2-relayd.instances = {
    ipu6 = {
      enable = true;
      cardLabel = "Intel MIPI Camera";
      input = {
        format = "NV12";
        pipeline = "icamerasrc";
      };
    output.format = "YUY2";
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
