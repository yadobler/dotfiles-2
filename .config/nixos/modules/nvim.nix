{ pkgs, inputs ... }:
{
    programs.neovim = {
        enable = true;
    }
    environment.systemPackages = [
        inputs.nixvim-config.packages.${system}.default
    ];
}
