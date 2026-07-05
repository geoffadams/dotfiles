local u = require("util")

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

-- buffers + in/out
u.keymap("n", "<Tab>", '<Cmd>lua require "bafa".toggle()<CR>', "Switch buffers")
u.keymap("n", "<C-i>", "<C-i>")
