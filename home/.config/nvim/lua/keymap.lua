-- save
vim.keymap.set("n", "<C-S>", "<Cmd>silent! update | redraw<CR>")
vim.keymap.set({ "i", "x" }, "<C-S>", "<Esc><Cmd>silent! update | redraw<CR>")

-- windows
vim.keymap.set("n", "<C-h>", "<Cmd>wincmd h<CR>")
vim.keymap.set("n", "<C-j>", "<Cmd>wincmd j<CR>")
vim.keymap.set("n", "<C-k>", "<Cmd>wincmd k<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>wincmd l<CR>")
vim.keymap.set("n", "<C-S-h>", "<Cmd>wincmd H<CR>")
vim.keymap.set("n", "<C-S-j>", "<Cmd>wincmd J<CR>")
vim.keymap.set("n", "<C-S-k>", "<Cmd>wincmd K<CR>")
vim.keymap.set("n", "<C-S-l>", "<Cmd>wincmd L<CR>")

-- buffers
vim.keymap.set("n", "<Leader>j", "<Cmd>bprev<CR>")
vim.keymap.set("n", "<Leader>k", "<Cmd>bnext<CR>")
vim.keymap.set("n", "<Leader>bd", "<Cmd>lua MiniBufremove.delete()<CR>")
vim.keymap.set("n", "<Leader>bD", "<Cmd>lua MiniBufremove.delete(0, true)<CR>")

-- habit-breaking
vim.keymap.set("n", "<Up>", "")
vim.keymap.set("n", "<Down>", "")
vim.keymap.set("n", "<Left>", "")
vim.keymap.set("n", "<Right>", "")

-- backspace nav
vim.opt.backspace = { "indent", "eol", "start" }

-- terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- search
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")
