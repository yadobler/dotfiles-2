{ pkgs, ... }:
{
    imports = [
        # ./java.nix
    ];
    programs.nixvim = {

        plugins = {
        };

        extraPlugins = with pkgs.vimPlugins; [
            vim-astro
            gruvbox-baby
            ccc
        ] ++ [
            pkgs.google-java-format
            pkgs.ripgrep
            pkgs.lazygit
            pkgs.fzf
            pkgs.fd
        ]; 

        extraConfigLua = ''
            vim.cmd [[colorscheme gruvbox-baby]]

            -- hypr.conf
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.hypr = {
                install_info = {
                    url = "https://github.com/luckasRanarison/tree-sitter-hypr",
                    files = { "src/parser.c" },
                    branch = "master",
                },
                filetype = "hypr",
            }

            require('ccc').setup({
                highlighter = {
                    auto_enable = true,
                    lsp = true,
                },
                DEFAULT_OPTIONS = {
                    RGB      = true;         -- #RGB hex codes
                    RRGGBB   = true;         -- #RRGGBB hex codes
                    names    = true;         -- "Name" codes like Blue
                    RRGGBBAA = true;         -- #RRGGBBAA hex codes
                    rgb_fn   = true;         -- CSS rgb() and rgba() functions
                    hsl_fn   = true;         -- CSS hsl() and hsla() functions
                    css      = true;         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn   = true;         -- Enable all CSS *functions*: rgb_fn, hsl_fn
                    mode     = 'background'; -- Available modes: foreground, background
                }
            })
        '';
    };
}
