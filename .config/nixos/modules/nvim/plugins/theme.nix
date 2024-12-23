{ pkgs, ... }:
{
    programs.nixvim = {
        extraPlugins = with pkgs.vimPlugins; [
            gruvbox-baby
        ];

        extraConfigLua = ''
            vim.cmd [[colorscheme gruvbox-baby]]
        '';
    };
}
