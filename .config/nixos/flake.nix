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
    base16.url = "github:SenchoPens/base16.nix";
    nixvim.url = "github:yadobler/nixvim-config";
    binja.url =  "github:yadobler/binary_ninja_nixos";
    wkeys.url =  "github:ptazithos/wkeys";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, base16, ...} @inputs:
    let

      system = "x86_64-linux";
      username = "yukna";
      specialArgs = { inherit inputs; inherit system; inherit username; };

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
          base16.nixosModule { scheme = "${nixpkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml"; }
          #./theme.nix

          ({ config, pkgs, system, inputs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          ./configuration.nix
          # ./detect-hp-spectre-x360.nix
        ];
      };
    };
}
