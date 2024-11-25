#unpacking channels...
#building the system configuration...
#trace: evaluation warning: The option `plugins.lsp.servers.nil-ls' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.nil_ls'.
#trace: evaluation warning: The option `plugins.lsp.servers.lua-ls' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.lua_ls'.
#trace: evaluation warning: The option `plugins.lsp.servers.jdt-language-server' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.jdtls'.
#trace: evaluation warning: Nixvim: `plugins.web-devicons` was enabled automatically because the following plugins are enabled.
#This behaviour is deprecated. Please explicitly define `plugins.web-devicons.enable` or alternatively
#enable `plugins.mini.enable` with `plugins.mini.modules.icons` and `plugins.mini.mockDevIcons`.
#plugins.telescope
#plugins.neo-tree
#plugins.trouble
#
#trace: evaluation warning: The option `plugins.lsp.servers.nil-ls' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.nil_ls'.
#trace: evaluation warning: The option `plugins.lsp.servers.lua-ls' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.lua_ls'.
#trace: evaluation warning: The option `plugins.lsp.servers.jdt-language-server' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.jdtls'.
#trace: evaluation warning: Nixvim: `plugins.web-devicons` was enabled automatically because the following plugins are enabled.
#This behaviour is deprecated. Please explicitly define `plugins.web-devicons.enable` or alternatively
#enable `plugins.mini.enable` with `plugins.mini.modules.icons` and `plugins.mini.mockDevIcons`.
#plugins.telescope
#plugins.neo-tree
#p[sudo] password for yukna: 
#unpacking channels...
#building the system configuration...
#trace: evaluation warning: The option `plugins.lsp.servers.nil-ls' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.nil_ls'.
#trace: evaluation warning: The option `plugins.lsp.servers.lua-ls' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.lua_ls'.
#trace: evaluation warning: The option `plugins.lsp.servers.jdt-language-server' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.jdtls'.
#trace: evaluation warning: Nixvim: `plugins.web-devicons` was enabled automatically because the following plugins are enabled.
#This behaviour is deprecated. Please explicitly define `plugins.web-devicons.enable` or alternatively
#enable `plugins.mini.enable` with `plugins.mini.modules.icons` and `plugins.mini.mockDevIcons`.
#plugins.telescope
#plugins.neo-tree
#plugins.trouble
#
#trace: evaluation warning: The option `plugins.lsp.servers.nil-ls' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.nil_ls'.
#trace: evaluation warning: The option `plugins.lsp.servers.lua-ls' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.lua_ls'.
#trace: evaluation warning: The option `plugins.lsp.servers.jdt-language-server' defined in `/nix/store/j8nj4qyjshgc1077zanfb9f0c3aak8sc-source/.config/nixos/modules/nvim.nix' has been renamed to `plugins.lsp.servers.jdtls'.
#trace: evaluation warning: Nixvim: `plugins.web-devicons` was enabled automatically because the following plugins are enabled.
#This behaviour is deprecated. Please explicitly define `plugins.web-devicons.enable` or alternatively
#enable `plugins.mini.enable` with `plugins.mini.modules.icons` and `plugins.mini.mockDevIcons`.
#plugins.telescope
#plugins.neo-tree
#plugins.troublelugins.trouble



{ pkgs, inputs, ... }:
let 
jarTestDir = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
jarTestFiles = builtins.filter (file: builtins.match "com.microsoft.java.test.plugin-.*\\.jar" file != null) (builtins.attrNames (builtins.readDir jarTestDir));
javaTestPath = if (jarTestFiles != []) then "${jarTestDir}/${builtins.head jarTestFiles}" else throw "No matching JAR file found!";

jarDebugDir = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
jarDebugFiles = builtins.filter (file: builtins.match "com.microsoft.java.debug.plugin-.*\\.jar" file != null) (builtins.attrNames (builtins.readDir jarDebugDir));
javaDebugPath = if (jarDebugFiles != []) then "${jarDebugDir}/${builtins.head jarDebugFiles}" else throw "No matching JAR file found!";

lldbDebugPath = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
jdtlsPath = "${pkgs.jdt-language-server}/bin/jdtls";
javaExecutablePath = "${pkgs.openjdk17}/bin/java";

in
{
    imports = [inputs.nixvim.nixosModules.nixvim];
    programs.nixvim = {
        enable = true;
        colorschemes.tokyonight = {
            enable = true;
            settings = {
                style = "night";
                lualine_bold = true;
                on_colors = ''
                    function(colors)
                        local hsluv = require('tokyonight.hsluv')
                        local multiplier = 1.6

                        function checkLength(a)
                            if #a < 7 then
                                return a .. "0"
                            else
                                return a
                            end
                        end
    
                        for k, v in pairs(colors) do
                            if type(v) == 'string' and v ~= 'NONE' then
                                local hsv = hsluv.hex_to_hsluv(v)
                                hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
                                colors[k] = checkLength(hsluv.hsluv_to_hex(hsv))
                            elseif type(v) == 'table' then
                                for kk, vv in pairs(v) do
                                    local hsv = hsluv.hex_to_rgb(vv)
                                    hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
                                    colors[k][kk] = checkLength(hsluv.rgb_to_hex(hsv))
                                end
                            end
                        end
                    end
                    '';
            };
        };
        highlight = {
            "RainbowRed" = { fg = "#FF0071" ;};
            "RainbowYellow" = { fg = "#FFFB00" ;};
            "RainbowBlue" = { fg = "#61AFEF" ;};
            "RainbowOrange" = { fg = "#FFB151" ;};
            "RainbowGreen" = { fg = "#4CDB68" ;};
            "RainbowViolet" = { fg = "#FF80FF" ;};
            "RainbowCyan" = { fg = "#56B6C2" ;};
        };
        extraPlugins = with pkgs.vimPlugins; [
            nvim-web-devicons
            ccc-nvim 
            crates-nvim
            neodev-nvim
            impatient-nvim
            nvim-pqf
            vim-illuminate
            vim-sleuth
        ] ++ [
            pkgs.alejandra
            pkgs.astyle
            pkgs.black
            pkgs.google-java-format
            pkgs.prettierd
            pkgs.rustfmt
            pkgs.stylua
            pkgs.lldb_19
            pkgs.python3
            pkgs.python312Packages.six
        ]; 
#       ++[
#            (pkgs.vimUtils.buildVimPlugin {
#             pname = "tree-sitter-hyprlang";
#             version = "0.0.1";
#             src = pkgs.fetchFromGitHub {
#             owner = "luckasRanarison";
#             repo = "tree-sitter-hyprlang";
#             rev = "";
#             hash = "sha256-w6yn8aNcJMLRbzaRuj3gj4x2J/20wUROLM6j39wpZek=";
#             };
#             })
#       ];
        plugins = {
            lualine.enable = true;
            gitsigns = {
                enable = true;
                settings = {
                    signs = {
                        add = { text = "+"; };
                        change = { text = "~"; };
                        delete = { text = "_"; };
                        topdelete = { text = "‾"; };
                        changedelete = { text = "~"; };
                    };
                };
            };
            comment.enable = true;
            hop.enable = true;
            persistence.enable = true;
            todo-comments.enable = true;
            which-key = {
                enable = true;
                settings.spec = [
                {__unkeyed-1 = "<leader>c"; "desc" =  "[C]ode";}
                {__unkeyed-1 = "<leader>d"; "desc" =  "[D]ebug";}
                {__unkeyed-1 = "<leader>r"; "desc" =  "[R]ename";}
                {__unkeyed-1 = "<leader>s"; "desc" =  "[S]earch";}
                {__unkeyed-1 = "<leader>w"; "desc" =  "[W]orkspace";}
                {__unkeyed-1 = "<leader>t"; "desc" =  "[T]oggle";}
                {__unkeyed-1 = "<leader>h"; "desc" =  "Git [H]unk";}
                ];
            };
            markdown-preview = {
                enable = true;
                settings.theme = "dark";
            };
            indent-blankline = {
                enable = true;
                settings = {
                    indent = {
                        char = "│";
                        tab_char = "";
                        highlight = [
                            "RainbowRed"
                                "RainbowYellow"
                                "RainbowBlue"
                                "RainbowOrange"
                                "RainbowGreen"
                                "RainbowViolet"
                                "RainbowCyan"
                        ];
                    };
                    whitespace = {
                        highlight = [
                            "RainbowRed"
                                "RainbowYellow"
                                "RainbowBlue"
                                "RainbowOrange"
                                "RainbowGreen"
                                "RainbowViolet"
                                "RainbowCyan"
                        ];
                    };
                    scope = {
                        enabled = true;
                        show_exact_scope = true;
                    };
                };
                
            };
#           texmagic.enable = true;
            nvim-lightbulb.enable = true;
            neo-tree = {
                enable = true;
                enableDiagnostics = true;
                enableGitStatus = true;
                enableModifiedMarkers = true;
                enableRefreshOnWrite = true;
                closeIfLastWindow = true;
                popupBorderStyle = "single"; # Type: null or one of “NC”, “double”, “none”, “rounded”, “shadow”, “single”, “solid” or raw lua code
                    buffers = {
                        bindToCwd = false;
                        followCurrentFile.enabled = true;
                    };
                window = {
                    width = 40;
                    height = 15;
                    autoExpandWidth = false;
                    mappings = {
                        "<space>" = "none";
                    };
                };
            };
            cmp-nvim-lsp.enable = true;
            cmp-buffer.enable = true;
            cmp-path.enable = true;
            cmp-cmdline.enable = true;
            cmp_luasnip.enable = true;
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
                extraOptions = {
                    mode = "symbol";
                    maxwidth = 50;
                    ellipsis_char = "...";
                    menu = {
                        buffer = "[Buffer]";
                        nvim_lsp = "[LSP]";
                        luasnip = "[LuaSnip]";
                        nvim_lua = "[Lua]";
                        latex_symbols = "[Latex]";
                    };
                };
            };
            cmp = {
                enable = true;
                settings = {
                    snippet.expand.__raw = ''
                        function(args)
                            require('luasnip').lsp_expand(args.body)
                        end
                        '';
                    completion.completeopt = "menu,menuone,noinsert";
                    duplicates = {
                        nvim_lsp = 1;
                        luasnip = 1;
                        cmp_tabnine = 1;
                        buffer = 1;
                        path = 1;
                    };
                    sources = [
                    { name = "nvim_lsp"; priority = 1000;}
                    { name = "luasnip"; priority = 750;}
                    { name = "buffer"; priority = 500;}
                    { name = "path"; priority = 250;}
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
                    mapping.__raw = ''
                           cmp.mapping.preset.insert({
                                   ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
                                   ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
                                   ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                                   ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
                                   ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                                   ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
                                   ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                                   ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                                   ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                                   ['<C-e>'] = cmp.mapping.abort(),
                                   ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                                   ["<Tab>"] = cmp.mapping(
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
                                   end, { "i", "s" }),
                           })
                    '';
                };
            };
            project-nvim = {
                enable = true;
                enableTelescope = true;
                settings = {
                    patterns = [
                        "Cargo.toml"
                        "*.iml"
                        "*.pdf"
                        ".git"
                        "_darcs"
                        ".hg"
                        ".bzr"
                        ".svn"
                        "Makefile"
                        "package.json"
                        "config"
                        "config.*"
                    ];
                };
            };
            dap = {
                enable = true;
                signs = {
                    dapBreakpoint = {
                        text = "●";
                        texthl = "DapBreakpoint";
                    };
                    dapBreakpointCondition = {
                        text = "●";
                        texthl = "DapBreakpointCondition";
                    };
                    dapLogPoint = {
                        text = "◆";
                        texthl = "DapLogPoint";
                    };
                };
                adapters.servers = {
                    codelldb = {
                        port = "\${port}";
                        executable = {
                            command = "${lldbDebugPath}";
                            args = ["--port" "\${port}"];
                        };
                    }; 
                };
                extensions = {
                    dap-python = {
                        enable = true;
                    };
                    dap-ui = {
                        enable = true;
                        floating.mappings = {
                            close = ["<ESC>" "q"];
                        };
                    };
                    dap-virtual-text = {
                        enable = true;
                    };
                };
                configurations = {
                    c = [
                        {
                            name = "Launch file";
                            type = "codelldb";
                            request = "launch";
                            program.__raw = ''
                                function()
                                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                                end
                            '';
                            cwd = "\${workspaceFolder}";
                            stopOnEntry = false;
                        }
                    ];
                    
                    java = [
                        {
                            type = "java";
                            request = "launch";
                            name = "Debug (Attach) - Remote";
                            hostName = "127.0.0.1";
                            port = 5005;
                        }
                    ];
                };
            };
            telescope = {
                enable = true;
                extensions = {
                    fzf-native.enable = true;
                    ui-select.enable = true;
                    undo.enable = true;
                }; 
                settings = {
                    defaults = {
                        layout_config = {
                            preview_cutoff = 50;
                        };
                        mappings = {
                            i = {
                                "<C-u>" = false;
                                "<esc>".__raw = "require('telescope.actions').close";
                            };
                        };
                    };
                };
            };	
            trouble = {
                enable = true;
                settings.auto_close = true;
            };
            conform-nvim = {
                enable = true;
                settings = {
                    notifyOnError = true;
                    formattersByFt = {
                        c = ["astyle"];
                        html = [["prettierd" "prettier"]];
                        css = [["prettierd" "prettier"]];
                        javascript = [["prettierd" "prettier"]];
                        javascriptreact = [["prettierd" "prettier"]];
                        typescript = [["prettierd" "prettier"]];
                        typescriptreact = [["prettierd" "prettier"]];
                        java = ["google-java-format"];
                        python = ["black"];
                        lua = ["stylua"];
                        nix = ["alejandra"];
                        markdown = [["prettierd" "prettier"]];
                        rust = ["rustfmt"];
                    };
                };
            };
            lsp = {
                enable = true;
    #                onAttach = ''
    #                        function(client, bufnr)
    #                            require("lsp_signature").on_attach({
    #                                bind = true, -- This is mandatory, otherwise border config won't get registered.
    #                                handler_opts = {
    #                                    border = "single",
    #                                },
    #                            }, bufnr)
    #                            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    #                            if client.supports_method "textDocument/formatting" then
    #                                vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    #                                vim.api.nvim_create_autocmd("BufWritePre", {
    #                                    group = augroup,
    #                                    buffer = bufnr,
    #                                    callback = function()
    #                                        vim.lsp.buf.format { bufnr = bufnr }
    #                                    end
    #                                })
    #                            end
    #                        end
    #                        '';
                servers = {
                    clangd = {
                        enable = true;
                    };
                    gleam.enable = true;
                    jdt-language-server.enable = true;
                    lua-ls.enable = true;
                    nil-ls.enable = true;
                    pylsp.enable = true;
                };
            };
            treesitter = {
                enable = true;
                settings = {
                    auto_install = true;
                    sync_install = true;
                    indent.enable = true;
                    highlight = {
                        enable = true;
                        additional_vim_regex_highlighting = false;
                        disable.__raw = ''
                            function(lang, buf)
                                local max_filesize = 100 * 1024 -- 100 KB
                                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                                if ok and stats and stats.size > max_filesize then
                                    return true
                                end
                            end
                            '';
                    };
                };
                folding = true;
                nixvimInjections = true;
            };
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
            clangd-extensions.enable = true;
            rustaceanvim.enable = true;
            nvim-jdtls = {
                enable = true;
                cmd = [
                    "${jdtlsPath}" 
                    "--java-executable" "${javaExecutablePath}"
                ];
                data = "~/.cache/jdtls/workspace";
                settings = {
                    java = {
                        signatureHelp = true;
                        completion = true;
                    };
                };
                initOptions = {
                    bundles = [
                        "${javaTestPath}"
                        "${javaDebugPath}"
                    ];
                };
            };
        };
        extraConfigLua = ''

            -- locale
            vim.o.spelllang = vim.o.spelllang .. ",cjk" -- disable spellchecking for asian characters (VIM algorithm does not support it)
            vim.o.shortmess = vim.o.shortmess .. "c" -- don't show redundant messages from ins-completion-menu
            vim.o.shortmess = vim.o.shortmess .. "I" -- don't show the default intro message
            vim.o.whichwrap = vim.o.whichwrap .. ",<,>,[,],h,l"
            
            require('ibl.hooks').register(require('ibl.hooks').type.HIGHLIGHT_SETUP,
                        function()
                        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#FF0071" })
                        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#FFFB00" })
                        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#FFB151" })
                        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#4CDB68" })
                        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#FF80FF" })
                        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
                        end
            )
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

        require('telescope').setup{
            pickers = {
                colorscheme = {
                    enable_preview = true
                }
            }
        }
        require'nvim-web-devicons'.setup {
            override = {
                zsh = {
                    icon = "",
                    color = "#428850",
                    cterm_color = "65",
                    name = "Zsh"
                }
            };
            default = true;
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
                RRGGBBAA = true;        -- #RRGGBBAA hex codes
                rgb_fn   = true;        -- CSS rgb() and rgba() functions
                hsl_fn   = true;        -- CSS hsl() and hsla() functions
                css      = true;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn   = true;        -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes: foreground, background
                mode     = 'background'; -- Set the display mode.
                }
                })


        '';

        keymaps = [
        {  
            key = "j";
            action = "gj";
            mode = "n";
        }
        {  
            key = "k";
            action = "gk";
            mode = "n";
        }
        {  
            key = "gd";
            action.__raw = "require('telescope.builtin').lsp_definitions";
            options.desc = "LSP: [G]oto [D]efinition";
            mode = "n";
        }
        { 
            
            key = "gr";
            action.__raw = "require('telescope.builtin').lsp_references";
            options.desc = "LSP: [G]oto [R]eferences";
            mode = "n";
        }
        { 
            
            key = "gI";
            action.__raw = "require('telescope.builtin').lsp_implementations";
            options.desc = "LSP: [G]oto [I]mplementation";
            mode = "n";
        }
        { 
            
            key = "<leader>cd";
            action.__raw = "require('telescope.builtin').lsp_type_definitions";
            options.desc = "LSP: Type [D]efinition";
            mode = "n";
        }
        { 
            
            key = "<leader>cs";
            action.__raw = "require('telescope.builtin').lsp_document_symbols";
            options.desc = "LSP: [D]ocument [S]ymbols";
            mode = "n";
        }
        { 
            
            key = "<leader>ws";
            action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
            options.desc = "LSP: [W]orkspace [S]ymbols";
            mode = "n";
        }
        { 
            
            key = "<leader>rn";
            action.__raw = "vim.lsp.buf.rename";
            options.desc = "LSP: [R]e[n]ame";
            mode = "n";
        }
        { 
            
            key = "<leader>ca";
            action.__raw = "vim.lsp.buf.code_action";
            options.desc = "LSP: [C]ode [A]ction";
            mode = "n";
        }
        { 
            
            key = "K";
            action.__raw = "vim.lsp.buf.hover";
            options.desc = "LSP: Hover Documentation";
            mode = "n";
        }
        { 
            
            key = "gD";
            action.__raw = "vim.lsp.buf.declaration";
            options.desc = "LSP: [G]oto [D]eclaration";
            mode = "n";
        }
        {
            mode = "n";
            key = "<leader>cf";
            action = "<cmd>lua require('conform').format()<cr>";
            options = {
                silent = true;
                desc = "Format Buffer";
            };
        }
        {
            mode = "v";
            key = "<leader>cF";
            action = "<cmd>lua require('conform').format()<cr>";
            options = {
                silent = true;
                desc = "Format Lines";
            };
        }
        {
            mode = "n";
            key = "<leader>x";
            action = "+diagnostics/quickfix";
        }
        {
            mode = "n";
            key = "<leader>xx";
            action = "<cmd>Trouble diagnostics<cr>";
            options = {
                silent = true;
                desc = "Document Diagnostics (Trouble)";
            };
        }
        {
            mode = "n";
            key = "<leader>xX";
            action = "<cmd>Trouble workspace_diagnostics<cr>";
            options = {
                silent = true;
                desc = "Workspace Diagnostics (Trouble)";
            };
        }
        {
            mode = "n";
            key = "<leader>xt";
            action = "<cmd>Trouble todo<cr>";
            options = {
                silent = true;
                desc = "Todo (Trouble)";
            };
        }
        {
            mode = "n";
            key = "<leader>xQ";
            action = "<cmd>TodoQuickFix<cr>";
            options = {
                silent = true;
                desc = "Quickfix List (Trouble)";
            };
        }
        {
            mode = "n";
            key = "<leader>dB";
            action = "
                <cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>
                ";
            options = {
                silent = true;
                desc = "Breakpoint Condition";
            };
        }
        {
            mode = "n";
            key = "<leader>db";
            action = ":DapToggleBreakpoint<cr>";
            options = {
                silent = true;
                desc = "Toggle Breakpoint";
            };
        }
        {
            mode = "n";
            key = "<leader>dc";
            action = ":DapContinue<cr>";
            options = {
                silent = true;
                desc = "Continue";
            };
        }
        {
            mode = "n";
            key = "<leader>da";
            action = "<cmd>lua require('dap').continue({ before = get_args })<cr>";
            options = {
                silent = true;
                desc = "Run with Args";
            };
        }
        {
            mode = "n";
            key = "<leader>dC";
            action = "<cmd>lua require('dap').run_to_cursor()<cr>";
            options = {
                silent = true;
                desc = "Run to cursor";
            };
        }
        {
            mode = "n";
            key = "<leader>dg";
            action = "<cmd>lua require('dap').goto_()<cr>";
            options = {
                silent = true;
                desc = "Go to line (no execute)";
            };
        }
        {
            mode = "n";
            key = "<leader>di";
            action = ":DapStepInto<cr>";
            options = {
                silent = true;
                desc = "Step into";
            };
        }
        {
            mode = "n";
            key = "<leader>dj";
            action = "
                <cmd>lua require('dap').down()<cr>
                ";
            options = {
                silent = true;
                desc = "Down";
            };
        }
        {
            mode = "n";
            key = "<leader>dk";
            action = "<cmd>lua require('dap').up()<cr>";
            options = {
                silent = true;
                desc = "Up";
            };
        }
        {
            mode = "n";
            key = "<leader>dl";
            action = "<cmd>lua require('dap').run_last()<cr>";
            options = {
                silent = true;
                desc = "Run Last";
            };
        }
        {
            mode = "n";
            key = "<leader>do";
            action = ":DapStepOut<cr>";
            options = {
                silent = true;
                desc = "Step Out";
            };
        }
        {
            mode = "n";
            key = "<leader>dO";
            action = ":DapStepOver<cr>";
            options = {
                silent = true;
                desc = "Step Over";
            };
        }
        {
            mode = "n";
            key = "<leader>dp";
            action = "<cmd>lua require('dap').pause()<cr>";
            options = {
                silent = true;
                desc = "Pause";
            };
        }
        {
            mode = "n";
            key = "<leader>dr";
            action = ":DapToggleRepl<cr>";
            options = {
                silent = true;
                desc = "Toggle REPL";
            };
        }
        {
            mode = "n";
            key = "<leader>ds";
            action = "<cmd>lua require('dap').session()<cr>";
            options = {
                silent = true;
                desc = "Session";
            };
        }
        {
            mode = "n";
            key = "<leader>dt";
            action = ":DapTerminate<cr>";
            options = {
                silent = true;
                desc = "Terminate";
            };
        }
        {
            mode = "n";
            key = "<leader>du";
            action = "<cmd>lua require('dapui').toggle()<cr>";
            options = {
                silent = true;
                desc = "Dap UI";
            };
        }
        {
            mode = "n";
            key = "<leader>dw";
            action = "<cmd>lua require('dap.ui.widgets').hover()<cr>";
            options = {
                silent = true;
                desc = "Widgets";
            };
        }
        {
            mode = ["n" "v"];
            key = "<leader>de";
            action = "<cmd>lua require('dapui').eval()<cr>";
            options = {
                silent = true;
                desc = "Eval";
            };
        }
        {
            mode = "n";
            key = "<Esc>";
            action = "<cmd>nohlsearch<CR>";
        }
        {
            mode = "n";
            key = "<leader>cp";
            action = "<cmd>MarkdownPreview<cr>";
            options = {
                desc = "Markdown Preview";
            };
        }
        { mode = "n"; key = "<leader>sh";       action.__raw = "require('telescope.builtin').help_tags"; options.desc = "[S]earch [H]elp";}
        { mode = "n"; key = "<leader>sk";       action.__raw = "require('telescope.builtin').keymaps"; options.desc = "[S]earch [K]eymaps";}
        { mode = "n"; key = "<leader>sf";       action.__raw = "require('telescope.builtin').find_files"; options.desc = "[S]earch [F]iles";}
        { mode = "n"; key = "<leader>ss";       action.__raw = "require('telescope.builtin').builtin"; options.desc = "[S]earch [S]elect Telescope";}
        { mode = "n"; key = "<leader>sw";       action.__raw = "require('telescope.builtin').grep_string"; options.desc = "[S]earch current [W]ord";}
        { mode = "n"; key = "<leader>sg";       action.__raw = "require('telescope.builtin').live_grep"; options.desc = "[S]earch by [G]rep";}
        { mode = "n"; key = "<leader>sd";       action.__raw = "require('telescope.builtin').diagnostics"; options.desc = "[S]earch [D]iagnostics";}
        { mode = "n"; key = "<leader>sr";       action.__raw = "require('telescope.builtin').resume"; options.desc = "[S]earch [R]esume";}
        { mode = "n"; key = "<leader>s.";       action.__raw = "require('telescope.builtin').oldfiles"; options.desc = "[S]earch Recent Files ('.' for repeat)";}
        { mode = "n"; key = "<leader><leader>"; action.__raw = "require('telescope.builtin').buffers"; options.desc = "[ ] Find existing buffers";}
        { 
            mode = "n"; key = "<leader>/"; action.__raw = ''
                function()
                require(telescope.builtin).current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                        winblend = 10,
                        previewer = false,
                        })
            end 
                '';
            options.desc = "[/] Fuzzily search in current buffer";
        }

        { 
            mode = "n"; key = "<leader>s/"; action.__raw = ''
                function()
                require(telescope.builtin).live_grep {
                    grep_open_files = true,
                                    prompt_title = 'Live Grep in Open Files',
                }
            end 
                '';
            options.desc = "[S]earch [/] in Open Files";
        }
        { 
            mode = "n"; key = "<leader>sn"; action.__raw = ''
                function()
                require(telescope.builtin).find_files { cwd = vim.fn.stdpath 'config' }
            end
                '';
            options.desc = "[S]earch [N]eovim files";
        }
        ];

        globals.rainbow_delimiters.__raw = ''
                    {highlight = {
                         "RainbowRed",
                         "RainbowYellow",
                         "RainbowBlue",
                         "RainbowOrange",
                         "RainbowGreen",
                         "RainbowViolet",
                         "RainbowCyan",
                     }}
        '';
        globals.autochdir = false;
        globals.loaded_netrw = 1;
        globals.loaded_newrwPlugin = 1;

# Display
        globals.have_nerd_font = true;
        opts.termguicolors = true;
        opts.guifont = "FiraCode NFP:h13";
        opts.encoding = "utf-8";
        opts.showmode = false;
        opts.laststatus = 2;
        opts.background = "dark";
        opts.backspace = "indent,eol,start";

# Timeouts
        opts.timeoutlen = 500;
        opts.ttimeout = true;
        opts.ttimeoutlen = 5;
        opts.updatetime = 250;

# Visual Updating
        opts.signcolumn = "yes";
        opts.scrolloff = 5;
        opts.showmatch = true;
        opts.errorbells = false;

# Mouse
        opts.mouse = "nv";
        opts.mousefocus = true;

# Numbering
        opts.number = true;
        opts.relativenumber = true;
        opts.ruler = false;

# Autoformatting
        opts.autoindent = true;
        opts.expandtab = true;
        opts.shiftwidth = 4;
        opts.tabstop = 4;
        opts.softtabstop = 4;
        opts.smartindent = true;
        opts.wrap = false;
        opts.foldenable = true;
        opts.foldlevel = 99;
        opts.foldlevelstart = 99;
        opts.foldmethod = "manual";
        opts.copyindent = true;

# Search
        opts.ignorecase = true;
        opts.smartcase = true;
        opts.hlsearch = true;

# Metadata
        opts.history = 100;
        opts.undofile = true;

# Preview substitutions live, as you type!
        opts.inccommand = "split";

# Fillchars
        opts.fillchars = {
            vert = "│";
            fold = "⠀";
            eob = " ";
# suppress ~ at EndOfBuffer
            diff = "░"; # alternatives = ⣿ ░ ─ ╱
                msgsep = "‾";
            foldopen = "▾";
            foldsep = "│";
            foldclose = "▸";
        };
# leader keys
        globals.mapleader = " ";
        globals.localmapleader = " ";

        autoCmd = [
        {
#       restore cursor
            command = "silent! normal! g`\"zv";
            desc = "return cursor to where it was last time closing the file";
            pattern = ["*"];
            event = ["BufWinEnter"];
        }
        {
            command = "normal! <Cmd>noh<cr>";
            event = ["InsertEnter"];
            pattern = ["*"];
        }
        ];
    };
}
