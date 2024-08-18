{ pkgs, ... }:
let
  ipuVersion = "ipu6ep";
  ipu6-camera-bins = pkgs.stdenv.mkDerivation {
    name = "ipu6-camera-bins";
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
    name = "ipu6ep-camera-hal";
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
  ivsc-firmware = pkgs.stdenv.mkDerivation {
    name = "ivsc-firmware";
    src = pkgs.fetchFromGitHub {
      sha256 = "sha256-GuD1oTnDEs0HslJjXx26DkVQIe0eS+js4UoaTDa77ME=";
      owner = "intel";
      repo = "ivsc-firmware";
      rev = "29c5eff4cdaf83e90ef2dcd2035a9cdff6343430";
    };
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/firmware/vsc/soc_a1_prod

      cp firmware/ivsc_pkg_hi556_0.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_pkg_hi556_0_a1_prod.bin
      cp firmware/ivsc_skucfg_hi556_0_1.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_skucfg_hi556_0_1_a1_prod.bin
      cp firmware/ivsc_fw.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_fw_a1_prod.bin
      runHook postInstall
      '';
  };
in
{
  environment.systemPackages = [
    ipu6-camera-bins
    pkgs.ipu6-camera-bins
    pkgs.linuxKernel.packages.linux_6_6.ipu6-drivers
    pkgs.linuxKernel.packages.linux_6_6.ivsc-driver
    pkgs.gst_all_1.icamerasrc-ipu6ep
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.v4l-utils
  ];
  hardware.firmware = [ 
    ivsc-firmware
  ];
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

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
