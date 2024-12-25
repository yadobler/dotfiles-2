{ pkgs, ... }:
{

        extraPlugins = with pkgs.vimPlugins; [
            gruvbox-baby
        ];

        extraConfigLua = ''
                vim.g.gruvbox_baby_telescope_theme = 1
                vim.g.gruvbox_baby_background_color = "dark"
                vim.cmd[[colorscheme gruvbox-baby]]
        '';
}
