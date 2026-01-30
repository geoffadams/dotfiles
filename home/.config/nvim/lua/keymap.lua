vim.g.mapleader = " "

-- Save
vim.keymap.set("n", "<C-S>", "<Cmd>silent! update | redraw<CR>")
vim.keymap.set({ "i", "x" }, "<C-S>", "<Esc><Cmd>silent! update | redraw<CR>")

-- Window nav
vim.keymap.set("n", "<C-H>", "<Cmd>wincmd h<CR>")
vim.keymap.set("n", "<C-J>", "<Cmd>wincmd j<CR>")
vim.keymap.set("n", "<C-K>", "<Cmd>wincmd k<CR>")
vim.keymap.set("n", "<C-L>", "<Cmd>wincmd l<CR>")

-- Buffer navs
vim.keymap.set("n", "<Leader>j", "<Cmd>bprev<CR>")
vim.keymap.set("n", "<Leader>k", "<Cmd>bnext<CR>")
vim.keymap.set("n", "<Leader>bd", "<Cmd>lua MiniBufremove.delete()<CR>")
vim.keymap.set("n", "<Leader>bD", "<Cmd>lua MiniBufremove.delete(0, true)<CR>")

-- Disable arrow keys
vim.keymap.set("n", "<Up>", "")
vim.keymap.set("n", "<Down>", "")
vim.keymap.set("n", "<Left>", "")
vim.keymap.set("n", "<Right>", "")

-- Backspace
vim.opt.backspace = { "indent", "eol", "start" }
