# based off https://github.com/shaunsingh/nix-darwin-dotfiles/blob/8fd7c6b5e3fd77e570ad163bdb8a5b2f451c115a/overlays/derivations/phocus-oxocarbon.nix

{ pkgs }:
{ scheme }:

pkgs.stdenv.mkDerivation rec {
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
    --replace-fail "@bg0@" "#${scheme.palette.base00}" \
    --replace-fail "@bg1@" "#${scheme.palette.base01}" \
    --replace-fail "@bg2@" "#${scheme.palette.base02}" \
    --replace-fail "@bg3@" "#${scheme.palette.base03}" \
    --replace-fail "@bg4@" "#${scheme.palette.base03}" \
    --replace-fail "@red@" "#${scheme.palette.base0C}" \
    --replace-fail "@lred@" "#${scheme.palette.base0C}" \
    --replace-fail "@orange@" "#${scheme.palette.base0A}" \
    --replace-fail "@lorange@" "#${scheme.palette.base0A}" \
    --replace-fail "@yellow@" "#${scheme.palette.base0B}" \
    --replace-fail "@lyellow@" "#${scheme.palette.base0B}" \
    --replace-fail "@green@" "#${scheme.palette.base0D}" \
    --replace-fail "@lgreen@" "#${scheme.palette.base0D}" \
    --replace-fail "@cyan@" "#${scheme.palette.base08}" \
    --replace-fail "@lcyan@" "#${scheme.palette.base08}" \
    --replace-fail "@blue@" "#${scheme.palette.base07}" \
    --replace-fail "@lblue@" "#${scheme.palette.base07}" \
    --replace-fail "@purple@" "#${scheme.palette.base0E}" \
    --replace-fail "@lpurple@" "#${scheme.palette.base0E}" \
    --replace-fail "@pink@" "#${scheme.palette.base0C}" \
    --replace-fail "@lpink@" "#${scheme.palette.base0C}" \
    --replace-fail "@primary@" "#${scheme.palette.base05}" \
    --replace-fail "@secondary@" "#${scheme.palette.base04}"
    '';

  nativeBuildInputs = [ pkgs.nodePackages.sass ];
  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];


}
