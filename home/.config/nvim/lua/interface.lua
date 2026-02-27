require("mini.icons").setup()
require("mini.tabline").setup()
require("mini.statusline").setup()
require("mini.cmdline").setup()
require("mini.bufremove").setup()

-- theme
vim.opt.termguicolors = true
vim.opt.background = "dark"
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

-- cursor
local guicursor = {
    "n-v-c-sm:block",
    "i-ci-ve:ver25-blinkwait0-blinkon500-blinkoff500",
    "r-cr-o:hor20-blinkwait0-blinkon500-blinkoff500",
    "t:ver25-blinkwait0-blinkon500-blinkoff500-TermCursor",
}
vim.opt.guicursor = table.concat(guicursor, ",")
vim.opt.cursorline = true -- active line highlight

-- interface
vim.opt.mouse = "a" -- enable mouse in all modes
vim.opt.splitright = true -- split to right
vim.opt.splitbelow = true -- split to bottom

-- status
vim.opt.ruler = false -- no cursor co-ords in status

-- command line
vim.opt.wildmenu = true
vim.opt.wildmode = "noselect:lastused,full"
vim.opt.wildoptions = "fuzzy,pum,tagfile"
vim.opt.wildignorecase = true
vim.opt.wildignore = { ".git/*" }
vim.opt.showcmd = true -- display partial commands
vim.opt.showmode = false -- don't display current mode

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- pretty paths in titles
require("pretty-path").setup()
vim.opt.title = true
local titlestring = {
    "nvim",
    '[%{fnamemodify(getcwd(), ":t")}]',
    "%{v:lua.PrettyPath.pretty_path()}",
}
vim.opt.titlestring = table.concat(titlestring, " ")
