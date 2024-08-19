{ pkgs, inputs, ... }:
{
    imports = [inputs.nixvim.nixosModules.nixvim];
    programs.nixvim = {
        enable = true;
        colorschemes.gruvbox.enable = true;
        plugins.lightline.enable = true;
    };
}
