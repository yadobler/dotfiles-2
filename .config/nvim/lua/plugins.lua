return {
    {   -- vim-sleuth
        -- Detect tabstop and shiftwidth automatically
        'tpope/vim-sleuth',
    },
    {    -- commenting
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },
    {   -- gitsigns
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
    {    -- hop
        "phaazon/hop.nvim",
        branch = "v2",
        config = function()
            require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
        end
    },
    {   -- which-key
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require("which-key").setup {
                key_labels = {
                    ["<space>"] = "SPC",
                    ["<cr>"] = "RET",
                    ["<tab>"] = "TAB",
                },
            }

            -- Document existing key chains
            require('which-key').register {
                ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
                ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
                ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
                ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
                ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
                ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
            }
            -- visual mode
            require('which-key').register({
                ['<leader>h'] = { 'Git [H]unk' },
            }, { mode = 'v' })
        end,
    },
    {    -- devicons
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        enabled = vim.g.have_nerd_font,
        config = function ()
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
        end
    },
    {    -- Telescope
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-symbols.nvim",
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- If encountering errors, see telescope-fzf-native README for installation instructions
                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },

            {    -- telescope-lazy
                "tsakirist/telescope-lazy.nvim",
                config = function()
                    require("telescope").setup({
                        extensions = {
                            lazy = {
                                -- Optional theme (the extension doesn"t set a default theme)
                                theme = "ivy",
                                -- Whether or not to show the icon in the first column
                                show_icon = true,
                                -- Mappings for the actions
                                mappings = {
                                    open_in_browser = "<C-o>",
                                    open_in_file_browser = "<M-b>",
                                    open_in_find_files = "<C-f>",
                                    open_in_live_grep = "<C-g>",
                                    open_plugins_picker = "<C-b>", -- Works only after having called first another action
                                    open_lazy_root_find_files = "<C-r>f",
                                    open_lazy_root_live_grep = "<C-r>g",
                                },
                                -- Other telescope configuration options
                            },
                        },
                    })
                    require("telescope").load_extension("lazy")
                end
            },
        },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup {
                defaults = {
                    layout_config = {
                        preview_cutoff = 50,
                    },
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                            ["<esc>"] = actions.close
                        },
                    },
                },
                extensions = {
                    ['ui-select'] = {require('telescope.themes').get_dropdown()},
                },
            }

            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

            -- Slightly advanced example of overriding default behavior and theme
            vim.keymap.set('n', '<leader>/', function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            vim.keymap.set('n', '<leader>s/', function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = '[S]earch [/] in Open Files' })

            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set('n', '<leader>sn', function()
                builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end, { desc = '[S]earch [N]eovim files' })
        end
    },

    {    -- nvim-lspconfig
        "neovim/nvim-lspconfig",
        dependencies = {
            {    -- Mason
                "williamboman/mason.nvim",
                build = ":MasonUpdate", -- :MasonUpdate updates registry contents
            },
            {    -- Mason lspconfig
                "williamboman/mason-lspconfig.nvim",
            },
            { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
            { 'j-hui/fidget.nvim', opts = {} },
            { 'folke/neodev.nvim', opts = {} },
            { "ray-x/lsp_signature.nvim", },
            {    -- null-ls-mason
                "jay-babu/mason-null-ls.nvim",
                event = { "BufReadPre", "BufNewFile" },
                dependencies = {
                    "williamboman/mason.nvim",
                    "jose-elias-alvarez/null-ls.nvim",
                },
            },
        },
        config = function()
            require("mason").setup {
                PATH = "prepend",
            }
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format Lua code
                "lua_ls",
                "rust_analyzer",
                "marksman",
                "texlab",
                'gopls', -- go
                'zls',   -- zig
            })
            require('mason-tool-installer').setup { 
                ensure_installed = ensure_installed
            }
            require("mason-null-ls").setup({
                automatic_setup = true,
                automatic_installation = true,
                ensure_installed = ensure_installed
            })
            require('after.lspconfig')
        end
    },

    { -- Autoformat
        'stevearc/conform.nvim',
        lazy = false,
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format { async = true, lsp_fallback = true }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                -- javascript = { { "prettierd", "prettier" } },
            },
        },
    },

    {    -- nvim-cmp
        "hrsh7th/nvim-cmp",
        event = 'InsertEnter',
        dependencies = {
            {    -- luasnip
                "L3MON4D3/LuaSnip",
                build = 'make install_jsregexp',
                dependencies = {"rafamadriz/friendly-snippets"}
            },
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
        },
        config = function()
            require('after._cmp')
        end
    },
    {    -- nvim-dap-mason
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("mason-nvim-dap").setup({
                automatic_setup = true,
                ensure_installed = {},
                automatic_installation = true,
            })
        end
    },
    {    -- treesitter
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        config = function()
            require('after.ts_configs')
        end
    },
    { -- Collection of various small independent plugins/modules
        'echasnovski/mini.nvim',
        config = function()
            require('mini.ai').setup { n_lines = 500 }
            require('mini.surround').setup()
            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = vim.g.have_nerd_font }
            statusline.section_location = function()
                return '%2l:%-2v'
            end
        end,
    },

    {    -- lightbulb
        "kosayoda/nvim-lightbulb",
        dependencies = {"antoinemadec/FixCursorHold.nvim"},
        config = function()
            require("nvim-lightbulb").setup({autocmd = {enabled = true}})
        end
    },
    {    -- Todo
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {signs = false}
    },
    {    -- pqf
        "yorickpeterse/nvim-pqf",
        config = function()
            require("pqf").setup()
        end
    },
    {    -- trouble
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup()
        end
    },
    {    -- md-link follow 
        "jghauser/follow-md-links.nvim",
        lazy = true
    },
    {    -- zen + twilight
        "folke/zen-mode.nvim",
        lazy = true,
        dependencies = {"folke/twilight.nvim"},
        config = function()
            require("twilight").setup()
        end
    },
    {    -- persistance
        "folke/persistence.nvim",
        lazy = true,
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        config = function()
            require("persistence").setup()
        end
    },
    {    -- marks
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup()
        end
    },
    {    -- link visitor
        "xiyaowong/link-visitor.nvim",
        lazy = true
    },
    {    -- mkdir
        "jghauser/mkdir.nvim",
        lazy = true
    },
    {    -- peek.nvim
        "toppair/peek.nvim",
        build = "deno task --quiet build:fast",
        config = function ()
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end
    },
    {    -- nvim-ufo
        "kevinhwang91/nvim-ufo",
        dependencies = {"kevinhwang91/promise-async"},
        lazy = true
    },
    {    -- impatient
        "lewis6991/impatient.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("impatient")
        end
    },
    {    -- vim-illuminate
        "RRethy/vim-illuminate",
        config = function ()
            require("illuminate").configure()
        end
    },
    {    -- nvim-tree
        "nvim-tree/nvim-tree.lua",
        version = "*",
        config = function()
            require("nvim-tree").setup {
                sort_by = "name",
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = true
                },
            }
        end,
    },
    {    -- project
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                patterns = {
                    "Cargo.toml",
                    "*.iml",
                    "*.pdf",
                    ".git",
                    "_darcs",
                    ".hg",
                    ".bzr",
                    ".svn",
                    "Makefile",
                    "package.json",
                    "config",
                    "config.*",
                },
            }
            -- require("telescope").load_extension("projects")
        end
    },
    {    -- indent-blankline.nvim
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            vim.opt.termguicolors = true
            if os.getenv("TERM") ~= "linux" then
                vim.opt.list = true
                -- vim.opt.listchars:append "space:⋅"
                vim.opt.listchars:append "space: "
                vim.opt.listchars:append "eol: "
            end
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }
            local hooks = require "ibl.hooks"
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#FF0071" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#FFFB00" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#FFB151" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#4CDB68" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#FF80FF" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)

            vim.g.rainbow_delimiters = { highlight = highlight }
            require("ibl").setup {
                indent = {
                    char = "│",
                    tab_char = "",
                    highlight = highlight,
                },
                whitespace = {
                    highlight = highlight,
                },
                scope = {
                    enabled = true,
                    show_exact_scope = true,
                }
            }
            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end
    },
    {    -- colorizer
        "uga-rosa/ccc.nvim",
        config = function()
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
        end
    },

    -- Language plugins

    {    -- nabla
        "jbyuki/nabla.nvim",
        config = function()
            vim.keymap.set('n', '<leader>p', require("nabla").popup, { desc = '[P]op up Nabla Notation' })
        end
    },
    {    -- markdown-preview
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" }
    },
    {    -- jdtls
        "mfussenegger/nvim-jdtls",
        lazy = true
    },
    {    -- texmagic
        "jakewvincent/texmagic.nvim",
        config = function()
            require("texmagic").setup()
        end
    },
    {    -- kitty conf
        "fladson/vim-kitty",
        ft = {"kitty/kitty.conf"},
    },
    {    -- TS-hyprland
        "luckasRanarison/tree-sitter-hyprlang",
        dependencies = { "nvim-treesitter/nvim-treesitter" }
    },
    {    -- rust_analyzer
        "simrat39/rust-tools.nvim",
        lazy = true
    },
    {    -- crates.nvim
        "saecki/crates.nvim",
        version = "v0.3.0",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup()
        end
    },
    {    -- neodev lua completion
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup({
                -- add any options here, or leave empty to use the default settings
            })
        end
    },

    -- {    -- image viewing
    --     "3rd/image.nvim",
    --     config = function()
    --         require("image").setup({
    --             backend = "kitty",
    --             kitty_method = "normal",
    --             integrations = {
    --                 markdown = {
    --                     enabled = true,
    --                     clear_in_insert_mode = false,
    --                     download_remote_images = true,
    --                     only_render_image_at_cursor = false,
    --                     filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    --                 },
    --                 neorg = {
    --                     enabled = true,
    --                     clear_in_insert_mode = false,
    --                     download_remote_images = true,
    --                     only_render_image_at_cursor = false,
    --                     filetypes = { "norg" },
    --                 },
    --             },
    --             max_width = nil,
    --             max_height = nil,
    --             max_width_window_percentage = nil,
    --             max_height_window_percentage = 90,
    --             window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    --             window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    --             editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    --             tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    --             hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
    --         })
    --     end,
    -- },

}


