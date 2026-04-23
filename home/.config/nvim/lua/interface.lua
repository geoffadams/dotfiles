require("mini.icons").setup()
require("mini.tabline").setup()
require("mini.statusline").setup()
require("mini.cmdline").setup()
require("mini.bufremove").setup()

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

-- cursor
local guicursor = {
    "n-v-c-sm:block",
    "i-ci-ve:ver25-blinkwait0-blinkon500-blinkoff500",
    "r-cr-o:hor20-blinkwait0-blinkon500-blinkoff500",
    "t:ver25-blinkwait0-blinkon500-blinkoff500-TermCursor",
}
vim.opt.guicursor = table.concat(guicursor, ",")
vim.o.cursorline = true -- active line highlight

-- interface
vim.o.mouse = "a" -- enable mouse in all modes
vim.o.splitright = true -- split to right
vim.o.splitbelow = true -- split to bottom

-- status
vim.o.ruler = false -- no cursor co-ords in status

-- command line
vim.o.wildmenu = true
vim.o.wildmode = "noselect:lastused,full"
vim.o.wildoptions = "fuzzy,pum,tagfile"
vim.o.wildignorecase = true
vim.opt.wildignore = { ".git/*" }
vim.o.showcmd = true -- display partial commands
vim.o.showmode = false -- don't display current mode

-- clipboard
if vim.env.SSH_TTY ~= nil then
    vim.notify("osc52 enabled")
    local osc52 = require("vim.ui.clipboard.osc52")

    local function copy_reg(reg)
        local orig = osc52.copy(reg)
        return function(lines, regtype)
            -- Write to Vim's internal register
            vim.fn.setreg(reg, table.concat(lines, "\n"), regtype)

            -- Send OSC52 to local clipboard
            orig(lines, regtype)
            orig(lines, regtype)
        end
    end

    vim.g.clipboard = {
        name = "OSC 52 with register sync",
        copy = {
            ["+"] = copy_reg("+"),
            ["*"] = copy_reg("*"),
        },
        -- Do NOT use OSC52 paste, just use internal registers
        paste = {
            ["+"] = function()
                return vim.fn.getreg("+"), "v"
            end,
            ["*"] = function()
                return vim.fn.getreg("*"), "v"
            end,
        },
    }
else
    vim.notify("osc52 not enabled")
end
vim.opt.clipboard:append("unnamedplus")

-- pretty paths in titles
require("pretty-path").setup()
vim.o.title = true
local titlestring = {
    "nvim",
    '[%{fnamemodify(getcwd(), ":t")}]',
    "%{v:lua.PrettyPath.pretty_path()}",
}
vim.opt.titlestring = table.concat(titlestring, " ")

-- pickers
require("fzf-lua").register_ui_select(function(ui_opts, items)
    function clamp(val, min, max)
        if val < min then
            return min
        elseif val > max then
            return max
        else
            return val
        end
    end
    function to_percentage(val, total)
        return (val / total) * 100
    end
    function to_ratio_h(lines, total)
        if total == nil then
            total = vim.o.lines
        end
        return lines / total
    end
    function to_ratio_w(columns, total)
        if total == nil then
            total = vim.o.columns
        end
        return columns / total
    end
    function to_lines(ratio, total)
        if total == nil then
            total = vim.o.lines
        end
        return math.ceil(ratio * total)
    end
    function to_columns(ratio, total)
        if total == nil then
            total = vim.o.columns
        end
        return math.ceil(ratio * total)
    end

    local min_h, max_h = 0.15, 0.70
    local listui_h_pad = 2
    local preview_h_pad = 0

    local min_w, max_w = 0.20, 0.70
    local listui_w_pad = 9
    local preview_w_pad = 0

    if ui_opts.kind == "codeaction" then
        preview_h_pad = 20
        preview_w_pad = 10
        min_w = 0.5
    end

    local min_h_lines = to_lines(min_h)
    local max_h_lines = to_lines(max_h)
    local h_lines = clamp(#items + listui_h_pad + preview_h_pad, min_h_lines, max_h_lines)

    local longest_w = 0
    for _, e in ipairs(items) do
        local format_entry = ui_opts.format_item and ui_opts.format_item(e) or tostring(e)
        longest_w = math.max(tostring(format_entry):len(), longest_w)
    end

    local min_w_cols = to_columns(min_w)
    local max_w_cols = to_columns(max_w)
    local w_cols = clamp(longest_w + listui_w_pad + preview_w_pad, min_w_cols, max_w_cols)

    return {
        winopts = {
            height = to_ratio_h(h_lines),
            width = to_ratio_w(w_cols),
            row = 0.5,
            col = 0.5,
            preview = {
                vertical = "down:" .. to_percentage(preview_h_pad, h_lines) .. "%",
                layout = "vertical",
            },
        },
        fzf_opts = {
            ["--layout"] = "reverse-list",
            ["--info"] = "hidden",
        },
    }
end)

-- undotree
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>tu", function()
    require("undotree").open({
        command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
    })
end, { desc = "Undotree toggle" })

-- difftool
vim.cmd("packadd nvim.difftool")
