{ pkgs, ... }:
{
    programs.nixvim = {
        plugins = {
            cmp-calc.enable = true;
            cmp-dap.enable = true;
            cmp-spell.enable = true;
            cmp-emoji.enable = true;
            cmp-buffer.enable = true;
            cmp-cmdline.enable = true;
            cmp-path.enable = true;
            cmp-nvim-lsp.enable = true;
            cmp-nvim-lsp-signature-help.enable = true;
            cmp-treesitter.enable = true;
            cmp_luasnip.enable = true;
            cmp = {
                enable = true;
                autoEnableSources = true;

                filetype = {};
                settings = {
                    # Preselect first entry
                    completion.completeopt = "menu,menuone,noinsert";
                    sources = [
                        { name = "nvim_lsp"; priority = 100; }
                        { name = "nvim_lsp_signature_help"; priority = 100; }
                        { name = "nvim_lsp_document_symbol"; priority = 100; }
                        { name = "treesitter"; priority = 80; }
                        { name = "luasnip"; priority = 70; }
                        { name = "path"; priority = 25; }
                    ];

                    window = {
                        completion.border = "single";
                        documentation.border = "single";
                    };

                    performance = {
                        debounce = 60;
                        fetching_timeout = 200;
                        max_view_entries = 30;
                    };

                    mapping = {
                        "<Up>"      = "cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }";
                        "<Down>"    = "cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }";
                        "<C-p>"     = "cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }";
                        "<C-n>"     = "cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }";
                        "<C-k>"     = "cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }";
                        "<C-j>"     = "cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }";
                        "<C-u>"     = "cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' })";
                        "<C-d>"     = "cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' })";
                        "<C-Space>" = "cmp.mapping(cmp.mapping.complete(), { 'i', 'c' })";
                        "<C-e>"     = "cmp.mapping.abort()";
                        "<CR>"      = "cmp.mapping.confirm({ select = false })";
                        "<Tab>"     = ''
                            cmp.mapping(
                                    function(fallback)
                                        local cmp = require('cmp')
                                        local luasnip = require("luasnip")
                                        local has_words_before = function()
                                            unpack = unpack or table.unpack
                                            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                                            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil                                                                                         
                                        end
                                        if cmp.visible() then
                                            cmp.select_next_item()
                                        elseif luasnip.expand_or_jumpable() then
                                            luasnip.expand_or_jump()
                                        elseif has_words_before() then
                                            cmp.complete()
                                        else
                                            fallback()
                                        end
                                    end, { "i", "s" })
                            '';
                    };
                };
            };
            
            luasnip = {
                enable = true;
                settings = {
                    enable_autosnippets = true;
                    store_selection_keys = "<Tab>";
                };
                fromVscode = [
                {
                    lazyLoad = true;
                    paths = "${pkgs.vimPlugins.friendly-snippets}";
                }
                ];
            };

            lspkind = {
                enable = true;

                cmp.menu = {
                    nvim_lsp = "";
                    nvim_lua = "";
                    neorg = "[neorg]";
                    buffer = "";
                    calc = "";
                    git = "";
                    luasnip = "󰩫";
                    copilot = "";
                    emoji = "󰞅";
                    path = "";
                    spell = "";
                };

                symbolMap = {
                    Namespace = "󰌗";
                    Text = "󰊄";
                    Method = "󰆧";
                    Function = "󰡱";
                    Constructor = "";
                    Field = "󰜢";
                    Variable = "󰀫";
                    Class = "󰠱";
                    Interface = "";
                    Module = "󰕳";
                    Property = "";
                    Unit = "󰑭";
                    Value = "󰎠";
                    Enum = "";
                    Keyword = "󰌋";
                    Snippet = "";
                    Color = "󰏘";
                    File = "󰈚";
                    Reference = "󰈇";
                    Folder = "󰉋";
                    EnumMember = "";
                    Constant = "󰏿";
                    Struct = "󰙅";
                    Event = "";
                    Operator = "󰆕";
                    TypeParameter = "";
                    Table = "";
                    Object = "󰅩";
                    Tag = "";
                    Array = "[]";
                    Boolean = "";
                    Number = "";
                    Null = "󰟢";
                    String = "󰉿";
                    Calendar = "";
                    Watch = "󰥔";
                    Package = "";
                    Copilot = "";
                    Codeium = "";
                    TabNine = "";
                };

                extraOptions = {
                    maxwidth = 50;
                    ellipsis_char = "...";
                };
            };
        };
    };
}
