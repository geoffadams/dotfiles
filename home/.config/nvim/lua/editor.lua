vim.cmd("syntax enable")
vim.opt.encoding = "utf-8"

-- Appearance
vim.opt.showmatch = true    -- show matching parens

-- Search
vim.opt.ignorecase = true   -- case-insensitive search
vim.opt.incsearch = true    -- highlight active search
vim.opt.hlsearch = true     -- highlight previous search

-- Use system clipboard
vim.opt.clipboard:append("unnamedplus")

-- Automatic word wrapping
vim.opt.tw = 119
vim.opt.formatoptions:append({ t = true })

-- Tabs
indent = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = indent
vim.opt.shiftwidth = indent
vim.opt.softtabstop = indent
vim.opt.showtabline = indent

-- Whitespace
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars = {tab = "· ", trail = "·"}

-- Completions
require('mini.completion').setup()
vim.opt.wildmenu = true
