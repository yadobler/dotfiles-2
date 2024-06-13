-- local base_dir = vim.fn.expand("%:h")
-- if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
-- 	vim.opt.rtp:append(base_dir)
-- end

vim.g.autochdir = false
vim.g.loaded_netrw = 1
vim.g.loaded_newrwPlugin = 1

-- Display
vim.g.have_nerd_font = true
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
vim.opt.timeoutlen = 500
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 5
vim.opt.updatetime = 250

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
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.cmd [[autocmd! InsertEnter * call feedkeys("\<Cmd>noh\<cr>" , 'n')]]

-- Metadata
vim.opt.history = 100
vim.opt.undofile = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

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

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
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

vim.cmd("colorscheme habamax")
