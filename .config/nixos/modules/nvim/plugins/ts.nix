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
            };
            treesitter-textobjects = {
                enable = true;
                select = {
                    enable = true;
                    lookahead = true;
                    keymaps = {
                        "aa" = "@parameter.outer";
                        "ia" = "@parameter.inner";
                        "af" = "@function.outer";
                        "if" = "@function.inner";
                        "ac" = "@class.outer";
                        "ic" = "@class.inner";
                        "ii" = "@conditional.inner";
                        "ai" = "@conditional.outer";
                        "il" = "@loop.inner";
                        "al" = "@loop.outer";
                        "at" = "@comment.outer";
                    };
                };
                move = {
                    enable = true;
                    gotoNextStart = {
                        "]m" = "@function.outer";
                        "]]" = "@class.outer";
                    };
                    gotoNextEnd = {
                        "]M" = "@function.outer";
                        "][" = "@class.outer";
                    };
                    gotoPreviousStart = {
                        "[m" = "@function.outer";
                        "[[" = "@class.outer";
                    };
                    gotoPreviousEnd = {
                        "[M" = "@function.outer";
                        "[]" = "@class.outer";
                    };
                };
                swap = {
                    enable = true;
                    swapNext = {
                        "<leader>a" = "@parameters.inner";
                    };
                    swapPrevious = {
                        "<leader>A" = "@parameter.outer";
                    };
                };
            };
            treesitter-context.enable = true;
            clangd-extensions.enable = true;
            rustaceanvim.enable = true;
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
