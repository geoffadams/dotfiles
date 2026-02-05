vim.cmd("syntax enable")
vim.opt.encoding = "utf-8"

-- appearance
vim.opt.showmatch = true -- show matching parens
vim.opt.number = true -- display line numbers
vim.opt.signcolumn = "yes" -- alwasy display signs

-- search
vim.opt.ignorecase = true -- case-insensitive search
vim.opt.incsearch = true -- highlight active search
vim.opt.hlsearch = true -- highlight previous search

-- wrapping
vim.opt.tw = 119
vim.opt.formatoptions:append({ t = true })

-- tabs
local indent = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = indent
vim.opt.shiftwidth = indent
vim.opt.softtabstop = indent
vim.opt.showtabline = indent

-- whitespace
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars = { tab = "· ", trail = "·" }

-- crash recovery
vim.opt.updatetime = 250
