vim.o.mouse = "a"

-- appearance
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"

local ui2 = require("vim._core.ui2")
ui2.enable({
    enable = true,
    msg = {
        targets = {
            [""] = "msg",
            bufwrite = "msg",
            emsg = "msg",
            wmsg = "msg",
            echo = "msg",
            echomsg = "msg",
            echoerr = "msg",
            verbose = "pager",
            list_cmd = "pager",
            lua_print = "msg",
            lua_error = "pager",
        },
        pager = {
            height = 0.5,
        },
    },
})

local msgs = require("vim._core.ui2.messages")
local orig_set_pos = msgs.set_pos
msgs.set_pos = function(tgt)
    orig_set_pos(tgt)
    if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
        local line_count = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(ui2.wins.msg))
        vim.wo[ui2.wins.msg].scrolloff = 0
        pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
            relative = "tabline",
            height = math.min(line_count, math.floor(vim.o.lines / 4)),
            row = 0,
            col = 0,
            anchor = "NW",
            border = "rounded",
            style = "minimal",
        })
        vim.api.nvim_win_set_cursor(ui2.wins.msg, { line_count, 0 })
    end
    if tgt == "pager" and vim.api.nvim_win_is_valid(ui2.wins.pager) then
        vim.wo[ui2.wins.pager].scrolloff = 0
        pcall(vim.api.nvim_win_set_config, ui2.wins.pager, {
            relative = "editor",
            width = math.floor(vim.o.columns * 1),
            height = math.floor(vim.o.lines * 0.5),
            row = vim.o.lines - 2,
            col = 0,
            anchor = "SW",
            border = "rounded",
            style = "minimal",
        })
    end
end

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

-- windows
vim.o.splitright = true
vim.o.splitbelow = true

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

-- ui2
