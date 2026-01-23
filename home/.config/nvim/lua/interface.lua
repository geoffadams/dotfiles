-- Theme
vim.opt.termguicolors = true
vim.opt.background = "dark"
require("rose-pine").setup({
    variant = "dawn",
    dark_variant = "moon",
    styles = {italic = false}
})
vim.cmd("colorscheme rose-pine-moon")

-- Interface
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.wildmenu = true

-- GitGutter
-- require("vim-gitgutter")
vim.g.gitgutter_sign_colunm_always = 1