{ pkgs, ... }:
{
    programs.nixvim = {
        plugins = {
            treesitter = {
                enable = true;
                settings = {
                    auto_install = true;
                    sync_install = true;
                    indent.enable = true;
                    highlight.enable = true;
                    incremental_selection.enable = true;
                };
                folding = true;
                nixvimInjections = true;
                lint = {
                    enable = true;
                    lintersByFt = {
                        c = ["clangtidy"];
                        java = ["checkstyle"];
                        json = ["jsonlint"];
                        lua = ["selene"];
                        markdown = ["markdownlint"];
                        nix = ["nix"];
                        python = ["flake8" "pylint"];
                    };
                };
            };
            treesitter-context.enable = true;
            clangd-extensions.enable = true;
            rustaceanvim.enable = true;
        };

        extraPlugins = with pkgs.vimPlugins; [
            vim-astro
        ];

        extraConfigLua = ''
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
        '';
    };
}
