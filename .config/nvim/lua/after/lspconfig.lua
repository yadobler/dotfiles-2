local lspconfig = require("lspconfig")

local on_attach_global = function(client, bufnr)
    require("lsp_signature").on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      }
    }, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("mason-lspconfig").setup_handlers {
    function (server_name)
        lspconfig[server_name].setup {
            on_attach = on_attach_global,
            capabilities = capabilities,
            cmd = {
                vim.fn.stdpath("data") .. '/mason/bin/' .. server_name:gsub('_','%-'),
            },
        }
    end,

    ["wgsl_analyzer"] = function()
        lspconfig.wgsl_analyzer.setup {
            on_attach = on_attach_global,
            capabilities = capabilities,
            cmd = {
                vim.fn.stdpath("data") .. '/mason/bin/wgsl_analyzer.cmd',
            },
        }
    end,

    ["jdtls"] = function()
    end,

    ["rust_analyzer"] = function()
    end,

    ["fennel_language_server"] = function()
        lspconfig.fennel_language_server.setup {
            on_attach = on_attach_global,
            capabilities = capabilities,
            cmd_env = {VIRTUAL_ENV = vim.fn.expand("~/.qtile_venv/")};
            filetypes = {'fennel'},
            single_file_support = true,
            settings = {
                fennel = {
                    workspace = {
                        -- If you are using hotpot.nvim or aniseed,
                        -- make the server aware of neovim runtime files.
                        library = vim.api.nvim_list_runtime_paths(),
                    },
                    diagnostics = {
                        globals = {'vim'},
                    },
                },
            },
        }
    end,

    ["pylsp"] = function()
        lspconfig.pylsp.setup {
            on_attach = on_attach_global,
            capabilities = capabilities,
            cmd_env = {VIRTUAL_ENV = vim.fn.expand("~/.qtile_venv/")};
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = {
                            ignore = {'W391', 'E302', 'E501', 'E305', 'E126', 'W291', 'E123', 'E251'}
                        },
                    },
                }
            }
        }
    end,
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup {
            on_attach = on_attach_global,
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    },
                    completion = {
                        callSnippet = "Replace"
                    },
                    workspace = {
                        checkThirdParty = false,
                    }
                }
            }
        }
    end
}

