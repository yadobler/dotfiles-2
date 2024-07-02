{ lib, pkgs, ... }:
let
  terminal = pkgs.foot;
  binary_name = "footclient";
in
{
  options.terminal.postInstallScript = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Post-install script for module 1";
  };
  config = {
    terminal.postInstallScript = ''
      rm -rf /usr/bin/gnome-terminal
      ln -s ${terminal}/bin/${binary_name} /usr/bin/gnome-terminal
      '';

    environment.systemPackages = [
      terminal
    ];
  };
}
