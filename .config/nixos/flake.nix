{
    description = "An example NixOS configuration";
    inputs = {
        unstable = {
            url = "github:NixOS/nixpkgs/nixos-unstable"; 
        };
        nixpkgs-unstable = {
            url = "github:NixOS/nixpkgs/nixos-24.05";
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
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, ...} @inputs:
        let
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            overlay-unstable = final: prev: {
                unstable = import inputs.nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                };
            };
        in {
            nixosConfigurations.vellinator = nixpkgs.lib.nixosSystem {
                inherit system;
                inherit specialArgs;
                modules = [
                    ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
                        ./configuration.nix
                ];
            };
        };
}

