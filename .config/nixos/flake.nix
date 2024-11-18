{
    description = "An example NixOS configuration";
    inputs = {
        nixpkgs-stable = {
            url = "github:NixOS/nixpkgs/nixos-24.05";
        };
        nixpkgs = {
            url = "github:NixOS/nixpkgs/nixos-unstable"; 
        };
        hyprland = {
            url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; 
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };
        Hyprspace = {
            url = "github:KZDKM/Hyprspace";
            inputs.hyprland.follows = "hyprland";
        };
        hyprgrass = {
            url = "github:horriblename/hyprgrass";
            inputs.hyprland.follows = "hyprland"; # IMPORTANT
        };
        iio-hyprland = { 
            url = "github:JeanSchoeller/iio-hyprland";
        };
        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-stable, ...} @inputs:
        let
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };

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
                    ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
                        ./configuration.nix
                    # ./detect-hp-spectre-x360.nix
                ];
            };
        };
}

