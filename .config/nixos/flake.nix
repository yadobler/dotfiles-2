{
  description = "An example NixOS configuration";
  inputs = {
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Personal
    nixvim = {
      # url = "github:yadobler/nixvim-config/minimal";
      url = "github:yadobler/nixvim-config";
    };
    binja = {
      url =  "github:yadobler/binary_ninja_nixos";
    };
    wkeys = {
      url =  "github:yadobler/wkeys";
    };
    oxocarbon = {
      url = "github:nyoom-engineering/base16-oxocarbon";
      flake = false;
    };
    tinted-theming = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ...} @inputs:
    let

      system = "x86_64-linux";
      username = "yukna";
      colorSchemeName = "oxocarbon-dark";

      schemeFromYAML = import ./modules/themes/schemeFromYAML.nix;
      # colorScheme = schemeFromYAML "oxocarbon-dark" (builtins.readFile (inputs.oxocarbon + "/base16-oxocarbon-dark.yaml"));
      colorScheme = schemeFromYAML colorSchemeName (builtins.readFile (inputs.tinted-theming + "/base16/" + colorSchemeName + ".yaml"));
      specialArgs = { inherit inputs; inherit system; inherit username; inherit colorScheme; };

      overlay-stable = final: prev: {
        stable = import inputs.nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };

    in {
      nixosConfigurations.vellinator = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
          ({ config, pkgs, system, inputs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          ./configuration.nix
          ./ipu6ep_camera.nix
        ];
      };
    };
}
