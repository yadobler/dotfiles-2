{
  description = "An example NixOS configuration";
  inputs = {
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Local
    nixvim = {
      url = "github:yadobler/nixvim-config";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ...} @inputs:
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
          ({ config, pkgs, system, inputs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          ./configuration.nix
          # ./detect-hp-spectre-x360.nix
        ];
      };
    };
}
