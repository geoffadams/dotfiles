local u = require("util")
local mkeymap = require("mini.keymap")
mkeymap.setup()
local pairs = require("mini.pairs")
pairs.setup()

-- save
u.keymap("n", "<C-s>", "<Cmd>silent! update | redraw<CR>", "Save buffer")
u.keymap({ "i", "x" }, "<C-s>", "<Esc><Cmd>silent! update | redraw<CR>", "Save buffer")

-- windows
u.keymap("n", "<C-h>", "<Cmd>wincmd h<CR>", "Move to window to left")
u.keymap("n", "<C-j>", "<Cmd>wincmd j<CR>", "Move to window below")
u.keymap("n", "<C-k>", "<Cmd>wincmd k<CR>", "Move to window above")
u.keymap("n", "<C-l>", "<Cmd>wincmd l<CR>", "Move to window to right")
u.keymap("n", "<C-S-h>", "<Cmd>wincmd H<CR>", "Move window left")
u.keymap("n", "<C-S-j>", "<Cmd>wincmd J<CR>", "Move window down")
u.keymap("n", "<C-S-k>", "<Cmd>wincmd K<CR>", "Move window up")
u.keymap("n", "<C-S-l>", "<Cmd>wincmd L<CR>", "Move window right")

-- buffers
u.keymap("n", "<C-[>", "<Cmd>bprev<CR>", "Previous buffer")
u.keymap("n", "<C-]>", "<Cmd>bnext<CR>", "Next buffer")
u.keymap("n", "<Leader>bd", "<Cmd>lua MiniBufremove.delete()<CR>", "Drop buffer")
u.keymap("n", "<Leader>bD", "<Cmd>lua MiniBufremove.delete(0, true)<CR>", "Drop buffer, discard changes")
u.keymap("n", "<C-i>", "<C-i>", "Go to [count] newer cursor position in jump list")
u.keymap("n", "ga", function()
    if vim.fn.expand("#") == "" then
        vim.cmd.normal(":bnext")
    else
        vim.api.nvim_input("<C-6>")
    end
end, "Go to alternate file")

-- habit-breaking
u.keymap("n", "<Up>", "", "Disable arrow nav")
u.keymap("n", "<Down>", "", "Disable arrow nav")
u.keymap("n", "<Left>", "", "Disable arrow nav")
u.keymap("n", "<Right>", "", "Disable arrow nav")

-- backspace nav
vim.opt.backspace = { "indent", "eol", "start" }

-- terminal
u.keymap("t", "<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode")

-- search
u.keymap("n", "<Esc>", "<Cmd>nohlsearch<CR>", "Clear highlight")

-- help
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help" },
    callback = function(opts)
        u.keymap_buf("n", "gd", "<C-]>", "Go to definition", opts.buf)
    end,
})

-- quick close
local quick_close_filetypes = {
    "checkhealth",
    "help",
    "lspinfo",
    "man",
    "nofile",
    "qf",
    "startuptime",
}
local quick_close_buftypes = {
    "help",
    "nofile",
    "quickfix",
}
vim.api.nvim_create_autocmd("FileType", {
    callback = function(opts)
        if
            not vim.bo[opts.buf].modifiable
            or vim.tbl_contains(quick_close_filetypes, vim.bo[opts.buf].filetype)
            or vim.tbl_contains(quick_close_buftypes, vim.bo[opts.buf].buftype)
        then
            u.keymap_buf("n", "q", function()
                if #vim.api.nvim_list_wins() > 1 then
                    vim.api.nvim_win_close(0, false) --'<C-w>c'
                else
                    vim.cmd.normal("ga")
                end
            end, "Quick-close buffer", opts.buf)
        end
    end,
})

-- tab navigations + indents
function fallback_to_key(rhs)
    return {
        condition = function()
            return true
        end,
        action = function()
            return rhs
        end,
    }
end
local tab_steps = {
    "minisnippets_next",
    "minisnippets_expand",
    "vimsnippet_next",
    "pmenu_next",
    "increase_indent",
    fallback_to_key("<C-t>"),
}
local s_tab_steps =
    { "minisnippets_prev", "vimsnippet_prev", "pmenu_prev", "decrease_indent", fallback_to_key("<C-d>") }
mkeymap.map_multistep("i", "<Tab>", tab_steps)
mkeymap.map_multistep("i", "<S-Tab>", s_tab_steps)

-- pairways ops
mkeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
mkeymap.map_multistep("i", "<BS>", { "minipairs_bs" })
