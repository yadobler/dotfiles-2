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
