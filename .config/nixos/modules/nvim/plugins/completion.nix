{ pkgs, ... }:
{
    programs.nixvim = {
        plugins = {
            cmp-calc.enable = true;
            cmp-dap.enable = true;
            cmp-spell.enable = true;
            cmp-emoji.enable = true;
            cmp-buffer.enable = true;
            cmp-path.enable = true;
            cmp-nvim-lsp.enable = true;
            cmp-nvim-lsp-signature-help.enable = true;
            cmp-treesitter.enable = true;
            cmp_luasnip.enable = true;
            cmp = {
                enable = true;
                autoEnableSources = true;
                cmdline = {
                    "/" = {
                        mapping.__raw = "cmp.mapping.preset.cmdline()";
                        sources = [ { name = "buffer"; } ];
                    };

                    ":" = {
                        mapping.__raw = "cmp.mapping.preset.cmdline()";
                        sources = [
                        { name = "path"; }
                        {
                            name = "cmdline";
                            option.ignore_cmds = [
                                "Man"
                                    "!"
                            ];
                        }
                        ];
                    };
                };

                filetype = {};

                settings = {
# Preselect first entry
                    completion.completeopt = "menu,menuone,noinsert";
                    sources = [
                    {
                        name = "nvim_lsp";
                        priority = 100;
                    }
                    {
                        name = "nvim_lsp_signature_help";
                        priority = 100;
                    }
                    {
                        name = "nvim_lsp_document_symbol";
                        priority = 100;
                    }
                    {
                        name = "treesitter";
                        priority = 80;
                    }
                    {
                        name = "luasnip";
                        priority = 70;
                    }
                };

                extraPlugins = with pkgs.vimPlugins; [
                ];

                extraConfigLua = ''
                    '';
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
        }
