# from https://github.com/Misterio77/nix-colors/blob/main/lib/contrib/gtk-theme.nix 

{ pkgs }:
{ scheme }:

let
  rendersvg = pkgs.runCommand "rendersvg" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.resvg}/bin/resvg $out/bin/rendersvg
    '';
in
  pkgs.stdenv.mkDerivation {
    name = "generated-gtk-theme-${scheme.slug}";
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "WhiteSur-gtk-theme";
      rev = "a087b8f";
      sha256 = "sha256-n9wPWtC6OjUAUpZLB/I2uFCiJ+UrdE6NeZrbUc/LiE0=";
    };
    nativeBuildInputs = with pkgs; [
      dialog
      glib
      jdupes
      libxml2
      sassc
      util-linux
    ];
    buildInputs = with pkgs; [
      gnome-themes-extra
    ];
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
      patchShebangs "$file"
      done

      # Do not provide `sudo`, as it is not needed in our use case of the install script
      substituteInPlace libs/lib-core.sh --replace-fail '$(which sudo)' false

      # Provides a dummy home directory
      substituteInPlace libs/lib-core.sh --replace-fail 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' 'MY_HOME=/tmp'
      HOME=/build
      chmod 777 -R .
      patchShebangs .
      mkdir -p $out/share/themes
      mkdir bin

      ./install.sh -n ${scheme.slug} -d "$out/share/themes" 
      chmod 555 -R .
      '';
  }
