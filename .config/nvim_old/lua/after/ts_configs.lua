local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

-- hypr.conf
parser_config.hypr = {
    install_info = {
        url = "https://github.com/luckasRanarison/tree-sitter-hypr",
        files = { "src/parser.c" },
        branch = "master",
    },
    filetype = "hypr",
}
-- register filetype to parser:
-- vim.treesitter.language.register('<PARSER>', '<FILETYPE>')

require('nvim-treesitter.install').prefer_git = true
require('nvim-treesitter.configs').setup {
    ignore_install = {},
    modules = {},
    auto_install = true,
    sync_install = true,
    ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "json",
        "python",
        "markdown",
        "toml",
        "latex"
    },

    -- highlighting
    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files

        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },

    -- indenting
    indent = {
        enable = true
    },
}

-- folding
vim.cmd [[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    set nofoldenable
]]
