local lspconfig = require("lspconfig")

local on_attach_global = function(client, bufnr)
    require("lsp_signature").on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      }
    }, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    local opts = { noremap=true, silent=true }
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
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

