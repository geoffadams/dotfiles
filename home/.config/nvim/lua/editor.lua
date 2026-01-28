vim.cmd("syntax enable")
vim.opt.encoding = "utf-8"

-- Search
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

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
