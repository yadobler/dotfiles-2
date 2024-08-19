{ pkgs, inputs, system, ... }:
{
    #programs.neovim = {
    #    enable = true;
    #};
    environment.systemPackages = [
        inputs.nixvim.packages.${system}.default
    ];
}
