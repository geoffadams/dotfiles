vim.cmd("syntax enable")
vim.opt.encoding = "utf-8"

-- appearance
vim.opt.showmatch = true -- show matching parens
vim.opt.number = true -- display line numbers
vim.opt.relativenumber = true -- display relative numbers (hybrid)
vim.opt.signcolumn = "yes" -- always display signs
vim.opt.scrolloff = 10

-- search
vim.opt.incsearch = true -- highlight active search
vim.opt.hlsearch = true -- highlight previous search
vim.opt.ignorecase = true -- case-insenstive search
vim.opt.smartcase = true -- uppercase triggers case sensitivity

-- wrapping
vim.opt.wrap = false
vim.opt.textwidth = 0
vim.opt.wrapmargin = 10
vim.opt.breakindent = true
vim.opt.formatoptions:append({ t = true })
require("wrapping").setup({
    create_keymaps = false,
})
vim.keymap.set("n", "<Leader>tws", "<Plug>(wrapping-soft-wrap-mode)")
vim.keymap.set("n", "<Leader>twh", "<Plug>(wrapping-hard-wrap-mode)")
vim.keymap.set("n", "<Leader>tww", "<Plug>(wrapping-toggle-wrap-mode)")

-- tabs
local indent = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = indent
vim.opt.shiftwidth = indent
vim.opt.softtabstop = indent
vim.opt.showtabline = 2

-- whitespace
vim.opt.list = true
vim.opt.listchars = { tab = "· ", trail = "·" }

-- crash recovery
vim.opt.updatetime = 250
vim.opt.undofile = true

-- failure handling
vim.opt.confirm = true

-- ergonomics
require("mini.surround").setup()
require("mini.pairs").setup()

-- folds
vim.opt.foldcolumn = "auto:9"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
require("origami").setup({
    autoFold = {
        enabled = false,
    },
})
