-- interface
require("vim._core.ui2").enable({})
vim.o.mouse = "a" -- enable mouse in all modes
vim.o.splitright = true -- split to right
vim.o.splitbelow = true -- split to bottom
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"

-- command line
require("mini.cmdline").setup()
vim.o.wildmenu = true
vim.o.wildmode = "noselect:lastused,full"
vim.o.wildoptions = "fuzzy,pum,tagfile"
vim.o.wildignorecase = true
vim.opt.wildignore = { ".git/*" }
vim.o.showcmd = true -- display partial commands
vim.o.showmode = false -- don't display current mode

-- input
require("mini.input").setup()

-- cursor
local guicursor = {
    "n-v-c-sm:block",
    "i-ci-ve:ver25-blinkwait0-blinkon500-blinkoff500",
    "r-cr-o:hor20-blinkwait0-blinkon500-blinkoff500",
    "t:ver25-blinkwait0-blinkon500-blinkoff500-TermCursor",
}
vim.opt.guicursor = table.concat(guicursor, ",")
vim.o.cursorline = true -- active line highlight

-- buffers
require("mini.tabline").setup()
require("mini.bufremove").setup()

-- theme
vim.o.termguicolors = true
vim.o.background = "dark"
require("rose-pine").setup({
    variant = "moon",
    dark_variant = "moon",
    enable = {
        legacy_highlights = false,
    },
    styles = { italic = false, transparency = true },
    highlight_groups = {
        ColorfulWinSep = { link = "WinSeparator" },
        FidgetNotify = { fg = "subtle", bg = "overlay" },
        Visual = { bg = "foam" },
    },
})
vim.cmd("colorscheme rose-pine-moon")

-- status
vim.o.laststatus = 3
vim.o.ruler = false -- no cursor co-ords in status
local statusline = require("mini.statusline")
local visual = require("config/visual")
statusline.setup({
    content = {
        active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git = statusline.section_git({ trunc_width = 40 })
            local diff = statusline.section_diff({ trunc_width = 75 })
            local diagnostics = statusline.section_diagnostics({
                trunc_width = 75,
                signs = visual.icons.diagnostic_by_name,
            })
            local lsp = statusline.section_lsp({ trunc_width = 75 })
            local filename = statusline.section_filename({ trunc_width = 140 })
            local wrap_mode = require("wrapping").get_current_mode()
            local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
            local location = statusline.section_location({ trunc_width = 75 })
            local search = statusline.section_searchcount({ trunc_width = 75 })

            return statusline.combine_groups({
                { hl = mode_hl, strings = { mode } },
                { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
                "%<", -- Mark general truncate point
                { hl = "MiniStatuslineFilename", strings = { filename } },
                "%=", -- End left alignment
                { hl = "MiniStatuslineFileinfo", strings = { wrap_mode, fileinfo } },
                { hl = mode_hl, strings = { search, location } },
            })
        end,
    },
})

-- pretty paths in titles
require("pretty-path").setup()
vim.o.title = true
local titlestring = {
    "nvim",
    '[%{fnamemodify(getcwd(), ":t")}]',
    "%{v:lua.PrettyPath.pretty_path()}",
}
vim.opt.titlestring = table.concat(titlestring, " ")
