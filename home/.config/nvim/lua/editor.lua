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
