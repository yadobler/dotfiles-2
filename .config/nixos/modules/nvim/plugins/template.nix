{ pkgs, ... }:
{
    programs.nixvim = {

        plugins = {
        };

        extraPlugins = with pkgs.vimPlugins; [
        ] 

        extraConfigLua = ''
        '';
    };
}
