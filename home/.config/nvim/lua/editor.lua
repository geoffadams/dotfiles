vim.cmd("syntax enable")
vim.o.encoding = "utf-8"

-- appearance
vim.o.showmatch = true -- show matching parens
vim.o.number = true -- display line numbers
vim.o.relativenumber = true -- display relative numbers (hybrid)
vim.o.signcolumn = "yes" -- always display signs
vim.o.scrolloff = 10

-- search
vim.o.incsearch = true -- highlight active search
vim.o.hlsearch = true -- highlight previous search
vim.o.ignorecase = true -- case-insenstive search
vim.o.smartcase = true -- uppercase triggers case sensitivity

-- wrapping
vim.o.wrap = false
vim.o.textwidth = 0
vim.o.wrapmargin = 10
vim.o.breakindent = true
vim.opt.formatoptions:append({ t = true })
require("wrapping").setup({
    create_keymaps = false,
})
vim.keymap.set("n", "<Leader>tws", "<Plug>(wrapping-soft-wrap-mode)")
vim.keymap.set("n", "<Leader>twh", "<Plug>(wrapping-hard-wrap-mode)")
vim.keymap.set("n", "<Leader>tww", "<Plug>(wrapping-toggle-wrap-mode)")

-- tabs
local indent = 4
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = indent
vim.o.shiftwidth = indent
vim.o.softtabstop = indent
vim.o.showtabline = 2

-- whitespace
vim.o.list = true
vim.opt.listchars = { tab = "· ", trail = "·" }

-- crash recovery
vim.o.updatetime = 250
vim.o.undofile = true

-- failure handling
vim.o.confirm = true

-- ergonomics
require("mini.surround").setup()
require("mini.pairs").setup()

-- folds
vim.o.foldcolumn = "auto:9"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
require("origami").setup()
