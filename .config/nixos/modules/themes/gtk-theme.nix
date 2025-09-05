# based off https://github.com/Misterio77/nix-colors/blob/main/lib/contrib/gtk-theme.nix 

{ pkgs }:
{ scheme }:

pkgs.stdenv.mkDerivation rec {
  pname = "Yaru-Colors";
  version = "fb5d086";

  src = pkgs.fetchFromGitHub {
    owner = "Jannomag";
    repo = "Yaru-Colors";
    rev = version;
    hash = "sha256-sEATCqjMBn6LwgMQcL8pvEW4k6WAMjOpSbSO3ksQPEU=";
  };

  nativeBuildInputs = with pkgs; [
    sassc
    jdupes
    inkscape
    optipng
    python3
  ];
  buildInputs = with pkgs; [
    gtk3
    gnome-themes-extra
  ];
  propagatedBuildInputs = with pkgs; [
    humanity-icon-theme
    hicolor-icon-theme
  ];
  propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];

  dontDropIconThemeCache = true;

  postPatch = ''
      patchShebangs .
      patchShebangs src/*.sh

      substituteInPlace src/theme-script.sh \
        --replace-fail '/usr/bin/inkscape' '${pkgs.inkscape}/bin/inkscape' \
        --replace-fail '/usr/bin/optipng' '${pkgs.inkscape}/bin/optipng' \
        --replace-fail 'eea834' '${scheme.palette.base0A}' \
        --replace-fail '8c5e11' '${scheme.palette.base0C}' \
        --replace-fail 'c08625' '${scheme.palette.base07}' \
        --replace-fail '412d0b' '${scheme.palette.base0E}' \
        --replace-fail 'e9af4e' '${scheme.palette.base0D}' \
        --replace-fail 'EEA834 EEAD34 EEB234 EEB734 EEBC34 EEC134 EEC634 EECB34 EED034 EED534' '${scheme.palette.base0B} ${scheme.palette.base0B} ${scheme.palette.base07} ${scheme.palette.base07} ${scheme.palette.base09} ${scheme.palette.base09} ${scheme.palette.base08} ${scheme.palette.base08} ${scheme.palette.base0F} ${scheme.palette.base0F}'
      '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    src/theme-script.sh Amber -a
    mkdir -p $out/share/Themes
    mkdir -p $out/share/Icons
    cp ../Themes/* $out/share/Themes
    cp ../Icons/* $out/share/Icons

    jdupes --quiet --link-soft --recurse $out/share
    runHook postInstall
    '';

}
