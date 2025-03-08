# based off https://github.com/Misterio77/nix-colors/blob/main/lib/contrib/gtk-theme.nix 

{ pkgs }:
{ scheme }:

pkgs.stdenv.mkDerivation {
  pname = "whitesur-gtk-theme";
  version = "2024-11-18";

  src = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "whitesur-gtk-theme";
    rev = "2024-11-18";
    hash = "sha256-SSGb7EdJN8E4N8b98VO7oFTeOmhKEo/0qhso9410ihg=";
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
    gnome-themes-extra # adwaita engine for Gtk2
  ];

  postPatch = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
      patchShebangs "$file"
      done

      # Do not provide `sudo`, as it is not needed in our use case of the install script
      substituteInPlace libs/lib-core.sh --replace-fail '"$(which sudo)"' false
      substituteInPlace install.sh --replace-fail 'full_sudo ' 'echo '
      cd src

      find . -name "*" ! -name "*.svg" ! -name "*.png" -type f -print0 | while IFS= read -r -d ''' file; do
          sed -i 's/"#0860f2"/#${scheme.palette.base0A}/g' $file
          sed -i 's/"#242424"/#${scheme.palette.base00}/g' $file
          sed -i 's/"#2a2a2a"/#${scheme.palette.base01}/g' $file
          sed -i 's/"#333333"/#${scheme.palette.base02}/g' $file
          sed -i 's/"#3b3b3b"/#${scheme.palette.base0E}/g' $file
          sed -i 's/"#5294e2"/#${scheme.palette.base0F}/g' $file
          sed -i 's/"#565656"/#${scheme.palette.base03}/g' $file
          sed -i 's/"#dedede"/#${scheme.palette.base05}/g' $file
          sed -i 's/"#ffffff"/#${scheme.palette.base06}/g' $file
      done


      cd ..

      # Provides a dummy home directory
      substituteInPlace libs/lib-core.sh --replace-fail 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' 'MY_HOME=/tmp'
      '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    ./install.sh  --dest $out/share/themes --silent-mode --libadwaita --color dark || true
    jdupes --quiet --link-soft --recurse $out/share
    runHook postInstall
    '';
}
