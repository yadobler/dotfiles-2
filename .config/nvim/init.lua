local base_dir = vim.fn.expand("%:h")
if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
	vim.opt.rtp:append(base_dir)
end

vim.g.autochdir = false
vim.g.loaded_netrw = 1
vim.g.loaded_newrwPlugin = 1

-- Display
vim.opt.termguicolors = true
vim.opt.guifont = "FiraCode NFP:h13"
vim.opt.encoding = "utf-8"
vim.opt.showmode = false
vim.opt.laststatus = 2
vim.opt.background = "dark"
vim.opt.backspace = "indent,eol,start"

-- locale
vim.opt.spelllang:append "cjk" -- disable spellchecking for asian characters (VIM algorithm does not support it)
vim.opt.shortmess:append "c" -- don't show redundant messages from ins-completion-menu
vim.opt.shortmess:append "I" -- don't show the default intro message
vim.opt.whichwrap:append "<,>,[,],h,l"

-- Timeouts
vim.opt.timeoutlen = 1000
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 5
vim.opt.updatetime = 100

-- Visual Updating
vim.wo.signcolumn = "yes"
vim.opt.scrolloff = 5
vim.opt.showmatch = true
vim.opt.errorbells = false

-- Mouse
vim.opt.mouse = "nv"
vim.opt.mousefocus = true

-- Numbering
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = false

-- Autoformatting
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "manual"
vim.opt.copyindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Metadata
vim.opt.history = 100
vim.opt.undofile = true

-- Fillchars
vim.opt.fillchars = {
    vert = "│",
    fold = "⠀",
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "░", -- alternatives = ⣿ ░ ─ ╱
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸",
}

-- leader keys
vim.g.mapleader = " "
vim.g.localmapleader = " "

-- restore cursor
vim.api.nvim_create_autocmd({'BufWinEnter'}, {
  desc = 'return cursor to where it was last time closing the file',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
require("after")

-- clear highlight when insert mode
vim.cmd [[autocmd! InsertEnter * call feedkeys("\<Cmd>noh\<cr>" , 'n')]]
vim.cmd("cd "..base_dir)
vim.cmd("colorscheme habamax")
