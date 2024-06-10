{
    description = "An example NixOS configuration";
    inputs = {
        nixpkgs = { url = "github:NixOS/nixpkgs/nixos-24.05"; };
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
        iio-hyprland = { 
            url = "github:JeanSchoeller/iio-hyprland";
        };
    };

    outputs = { self, nixpkgs, ... } @ inputs: {
        nixosConfigurations.vellinator = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
                ./configuration.nix
            ];
        };
    };
}

