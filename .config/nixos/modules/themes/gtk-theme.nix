# based off https://github.com/shaunsingh/nix-darwin-dotfiles/blob/8fd7c6b5e3fd77e570ad163bdb8a5b2f451c115a/overlays/derivations/phocus-oxocarbon.nix

{ pkgs }:
{ scheme }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "phocus-oxocarbon";
  version = "0cf0eb35a927bffcb797db8a074ce240823d92de";

  src = pkgs.fetchFromGitHub {
    owner = "phocus";
    repo = "gtk";
    rev = version;
    sha256 = "sha256-URuoDJVRQ05S+u7mkz1EN5HWquhTC4OqY8MqAbl0crk=";
  };

  patches = [
    patches/remove-npm.diff
    patches/gradient.diff
    patches/accent-substitute-all.diff
  ];

  postPatch = ''
    substituteInPlace scss/gtk-3.0/_colors.scss \
    --replace "@bg0@" "#{scheme.palette.base00}" \
    --replace "@bg1@" "#{scheme.palette.base01}" \
    --replace "@bg2@" "#{scheme.palette.base02}"\
    --replace "@bg3@" "#{scheme.palette.base03}" \
    --replace "@bg4@" "#{scheme.palette.base03}" \
    --replace "@red@" "#{scheme.palette.base0C}" \
    --replace "@lred@" "#{scheme.palette.base0C}" \
    --replace "@orange@" "#{scheme.palette.base0A}" \
    --replace "@lorange@" "#{scheme.palette.base0A}" \
    --replace "@yellow@" "#{scheme.palette.base0B}" \
    --replace "@lyellow@" "#{scheme.palette.base0B}" \
    --replace "@green@" "#{scheme.palette.base0D}" \
    --replace "@lgreen@" "#{scheme.palette.base0D}" \
    --replace "@cyan@" "#{scheme.palette.base08}" \
    --replace "@lcyan@" "#{scheme.palette.base08}" \
    --replace "@blue@" "#{scheme.palette.base07}" \
    --replace "@lblue@" "#{scheme.palette.base07}" \
    --replace "@purple@" "#{scheme.palette.base0E}" \
    --replace "@lpurple@" "#{scheme.palette.base0E}" \
    --replace "@pink@" "#{scheme.palette.base0C}" \
    --replace "@lpink@" "#{scheme.palette.base0C}" \
    --replace "@primary@" "#{scheme.palette.base05}" \
    --replace "@secondary@" "#{scheme.palette.base04}"
    '';

  nativeBuildInputs = [ pkgs.sass ];
  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
}
