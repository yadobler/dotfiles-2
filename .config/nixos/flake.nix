{
    description = "An example NixOS configuration";
    inputs = {
        nixpkgs = { url = "github:NixOS/nixpkgs/nixos-24.05"; };
        nur = { url = "github:nix-community/NUR"; };
    };

    outputs ={ self, nixpkgs, ... }@inputs: {
        nixosConfigurations.vellinator = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = attrs;
            modules = [
                ./configuration.nix
            ];
        };
    };
}

