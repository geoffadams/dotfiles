-- theme
vim.o.termguicolors = true
vim.o.background = "dark"
require("rose-pine").setup({
    variant = "dawn",
    dark_variant = "moon",
    enable = {
        legacy_highlights = false,
    },
    styles = { italic = false, transparency = true },
    highlight_groups = {
        FidgetNotify = { fg = "subtle", bg = "overlay" },
    },
})
vim.cmd("colorscheme rose-pine-moon")

-- interface
require("mini.tabline").setup()
require("mini.bufremove").setup()
vim.o.mouse = "a" -- enable mouse in all modes
vim.o.splitright = true -- split to right
vim.o.splitbelow = true -- split to bottom

-- status
vim.o.ruler = false -- no cursor co-ords in status
require("mini.statusline").setup()

-- command line
require("mini.cmdline").setup()
vim.o.wildmenu = true
vim.o.wildmode = "noselect:lastused,full"
vim.o.wildoptions = "fuzzy,pum,tagfile"
vim.o.wildignorecase = true
vim.opt.wildignore = { ".git/*" }
vim.o.showcmd = true -- display partial commands
vim.o.showmode = false -- don't display current mode

-- cursor
local guicursor = {
    "n-v-c-sm:block",
    "i-ci-ve:ver25-blinkwait0-blinkon500-blinkoff500",
    "r-cr-o:hor20-blinkwait0-blinkon500-blinkoff500",
    "t:ver25-blinkwait0-blinkon500-blinkoff500-TermCursor",
}
vim.opt.guicursor = table.concat(guicursor, ",")
vim.o.cursorline = true -- active line highlight

-- pretty paths in titles
require("pretty-path").setup()
vim.o.title = true
local titlestring = {
    "nvim",
    '[%{fnamemodify(getcwd(), ":t")}]',
    "%{v:lua.PrettyPath.pretty_path()}",
}
vim.opt.titlestring = table.concat(titlestring, " ")
