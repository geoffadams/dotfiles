-- theme
vim.opt.termguicolors = true
vim.opt.background = "dark"
require("rose-pine").setup({
    variant = "dawn",
    dark_variant = "moon",
    styles = { italic = false, transparency = true },
})
vim.cmd("colorscheme rose-pine-moon")

-- mini.nvim
-- mini.nvim gui elements
require("mini.icons").setup()
require("mini.tabline").setup()
require("mini.statusline").setup()
require("mini.cmdline").setup()

-- interface
vim.opt.mouse = "a" -- enable mouse in all modes
vim.opt.cursorline = true -- active line highlight
vim.opt.number = true -- display line numbers
vim.opt.signcolumn = "yes" -- alwasy display signs
vim.opt.ruler = false -- no cursor co-ords in status
vim.opt.showcmd = true -- display partial commands
vim.opt.showmode = true -- display current mode

-- Filename in title
vim.opt.title = true
vim.opt.titlestring = 'nvim [%{fnamemodify(getcwd(), ":t")}] %{expand("%:~:.")}'

