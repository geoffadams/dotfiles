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
vim.opt.shortmess:append("cCIsS")

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
            local filename = statusline.section_filename({ trunc_width = 120 })

            local diagnostics_hl = "MiniStatuslineDevinfo"
            for severity_index, count in pairs(vim.diagnostic.count()) do
                if count > 0 then
                    diagnostics_hl = visual.highlight.diagnostic_block[severity_index]
                    break
                end
            end
            local diagnostics = statusline.section_diagnostics({
                trunc_width = 75,
                signs = visual.icons.diagnostic_by_name,
            })
            local lsp = statusline.section_lsp({ trunc_width = 75 })
            local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })

            local search = statusline.section_searchcount({ trunc_width = 75 })

            local wrap_mode = require("wrapping").get_current_mode() or "-"
            local wrap = wrap_mode:sub(1, 1) .. "/" .. vim.bo.textwidth
            local location = "%l:%L"

            return statusline.combine_groups({
                { hl = mode_hl, strings = { mode } },
                { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
                "%<", -- Mark general truncate point
                { hl = "MiniStatuslineFilename", strings = { filename } },
                "%=", -- End left alignment
                { hl = diagnostics_hl, strings = { diagnostics } },
                { hl = "MiniStatuslineDevinfo", strings = { lsp, fileinfo } },
                { hl = "MiniStatuslineFileinfo", strings = { wrap } },
                { hl = "CurSearch", strings = { search } },
                { hl = "MiniStatuslineFileinfo", strings = { location } },
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

-- icons
local icons = require("mini.icons")
icons.setup()
icons.tweak_lsp_kind()

-- scrollbar
local map = require("mini.map")
local dot_symbols = {
    "⠀",
    "⠁",
    "⠂",
    "⠃",
    "⠄",
    "⠅",
    "⠆",
    "⠇",
    "⡀",
    "⡁",
    "⡂",
    "⡃",
    "⡄",
    "⡅",
    "⡆",
    "⡇",
    resolution = { row = 4, col = 1 },
}
map.setup({
    symbols = {
        encode = dot_symbols,
        scroll_view = "▎",
        scroll_line = "▊",
    },
    window = {
        width = 2,
        winblend = 25,
        show_integration_count = false,
    },
    integrations = {
        map.gen_integration.builtin_search({
            search = "IncSearch",
        }),
        map.gen_integration.diagnostic({
            error = "DiagnosticFloatingError",
            warn = "DiagnosticFloatingWarn",
        }),
        map.gen_integration.gitsigns(),
    },
})
local map_buftypes = { "", "terminal" }
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(opts)
        if vim.tbl_contains(map_buftypes, vim.bo[opts.buf].buftype) then
            map.open()
        else
            map.close()
        end
    end,
})
