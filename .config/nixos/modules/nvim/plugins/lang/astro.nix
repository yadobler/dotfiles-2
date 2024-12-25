{ pkgs, ... }:
{
    extraPlugins = with pkgs.vimPlugins; [
        vim-astro
    ];
}
