return {
    {    -- hop
        "phaazon/hop.nvim",
        branch = "v2",
        config = function()
            require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
        end
    },
    {    -- commenting
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },
    {    -- whichkey
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
                key_labels = {
                    ["<space>"] = "SPC",
                    ["<cr>"] = "RET",
                    ["<tab>"] = "TAB",
                },
            }
        end
    },
    {    -- trouble
        "folke/trouble.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        config = function()
            require("trouble").setup()
        end
    },
    {    -- Plenary
        "nvim-lua/plenary.nvim",
        lazy = true
    },
    {    -- telescope-symbols
        "nvim-telescope/telescope-symbols.nvim",
        lazy = true
    },
    {    -- Telescope
        "nvim-telescope/telescope.nvim",
        dependencies = {"nvim-lua/plenary.nvim"},
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
                }
            }
        end
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
    {    -- nvim-autopairs
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {
                disable_filetype = { "TelescopePrompt" , "vim", "tex" },
            }
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
    {    -- jdtls
        "mfussenegger/nvim-jdtls",
        lazy = true
    },
    {    -- barbar
        "romgrk/barbar.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        init = function() vim.g.barbar_auto_setup = true end,
    },
    {    -- feline
        "famiu/feline.nvim",
        config = function ()
           require("feline").setup{}
        end
    },
    {    -- barbecue
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            exclude_filetypes = { "veil", "toggleterm" }
        },
    },
    {    -- texmagic
        "jakewvincent/texmagic.nvim",
        config = function()
            require("texmagic").setup()
        end
    },
    {    -- nabla
        "jbyuki/nabla.nvim",
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
    {    -- markdown-preview
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" }
    },
    {    -- impatient
        "lewis6991/impatient.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("impatient")
        end
    },
    {    -- devicons
        "nvim-tree/nvim-web-devicons",
        lazy = true,
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
    {    -- nvim-cmp icons
        "onsails/lspkind.nvim",
        lazy = true
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
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
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
    {    -- image viewing
        "3rd/image.nvim",
        config = function()
            require("image").setup({
                backend = "kitty",
                kitty_method = "normal",
                integrations = {
                    markdown = {
                        enabled = true,
                        clear_in_insert_mode = false,
                        download_remote_images = true,
                        only_render_image_at_cursor = false,
                        filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
                    },
                    neorg = {
                        enabled = true,
                        clear_in_insert_mode = false,
                        download_remote_images = true,
                        only_render_image_at_cursor = false,
                        filetypes = { "norg" },
                    },
                },
                max_width = nil,
                max_height = nil,
                max_width_window_percentage = nil,
                max_height_window_percentage = 90,
                window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
                window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
                editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
                tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
                hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
            })
        end,
    },
    {    -- treesitter
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
    },
    {    -- kitty conf
        "fladson/vim-kitty",
        ft = {"kitty/kitty.conf"},
    },
    {    -- TS-hyprland
        "luckasRanarison/tree-sitter-hyprlang",
        dependencies = { "nvim-treesitter/nvim-treesitter" }
    },
    {    -- luasnip
        "L3MON4D3/LuaSnip",
        dependencies = {"rafamadriz/friendly-snippets"}
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
        config = function()
            require("todo-comments").setup()
        end
    },
    {    -- Mason
        "williamboman/mason.nvim",
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
        config = function()
            require("mason").setup {
                PATH = "prepend",
            }
        end
    },
    {    -- Mason lspconfig
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup {
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "marksman",
                    "jdtls",
                    "clangd",
                    "texlab",
                },
            }
        end
    },
    {    -- nvim-dap
        "mfussenegger/nvim-dap",
        lazy = true,
    },
    {    -- nvim-dap-ui
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap"},
        lazy = true,
    },
    {    -- nvim-dap-mason
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {"williamboman/mason.nvim", "mfussenegger/nvim-dap"},
        config = function()
            require("mason-nvim-dap").setup({
                automatic_setup = true,
                ensure_installed = {},
                automatic_installation = true,
            })
        end
    },
    {    -- null-ls-mason
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "jose-elias-alvarez/null-ls.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                automatic_setup = true,
                automatic_installation = true,
                ensure_installed = {}
            })
        end,
    },
    {    -- nvim-lspconfig
        "neovim/nvim-lspconfig",
        lazy = true
    },
    {    -- nvim-cmp
        "hrsh7th/nvim-cmp",
        lazy = true,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
        }
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
    {    -- nvim signatures
        "ray-x/lsp_signature.nvim",
        lazy = true
    },
    {    -- pqf
        "yorickpeterse/nvim-pqf",
        config = function()
            require("pqf").setup()
        end
    },
}
