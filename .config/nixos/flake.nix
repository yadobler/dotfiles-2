{
    description = "An example NixOS configuration";
    inputs = {
        nixpkgs-unstable = {
            #url = "github:NixOS/nixpkgs/nixos-24.05";
            url = "github:NixOS/nixpkgs/nixos-unstable"; 
        };
        nixpkgs = {
            url = "github:NixOS/nixpkgs/nixos-unstable"; 
        };
        nix-ld = {
            url = "github:Mic92/nix-ld";
            inputs.nixpkgs.follows = "nixpkgs";
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
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, nix-ld, ...} @inputs:
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
                        ./detect-hp-spectre-x360.nix
                ];
            };
        };
}

