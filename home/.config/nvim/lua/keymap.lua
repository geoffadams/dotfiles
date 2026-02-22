-- save
vim.keymap.set("n", "<C-S>", "<Cmd>silent! update | redraw<CR>", { desc = "Save buffer" })
vim.keymap.set({ "i", "x" }, "<C-S>", "<Esc><Cmd>silent! update | redraw<CR>", { desc = "Save buffer" })

-- windows
vim.keymap.set("n", "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Move to window to left" })
vim.keymap.set("n", "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Move to window below" })
vim.keymap.set("n", "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Move to window above" })
vim.keymap.set("n", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Move to window to right" })
vim.keymap.set("n", "<C-S-h>", "<Cmd>wincmd H<CR>", { desc = "Move window left" })
vim.keymap.set("n", "<C-S-j>", "<Cmd>wincmd J<CR>", { desc = "Move window down" })
vim.keymap.set("n", "<C-S-k>", "<Cmd>wincmd K<CR>", { desc = "Move window up" })
vim.keymap.set("n", "<C-S-l>", "<Cmd>wincmd L<CR>", { desc = "Move window right" })

-- buffers
vim.keymap.set("n", "<Leader>j", "<Cmd>bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<Leader>k", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<Leader>bd", "<Cmd>lua MiniBufremove.delete()<CR>", { desc = "Drop buffer" })
vim.keymap.set(
    "n",
    "<Leader>bD",
    "<Cmd>lua MiniBufremove.delete(0, true)<CR>",
    { desc = "Drop buffer, discard changes" }
)

-- habit-breaking
vim.keymap.set("n", "<Up>", "", { desc = "Disable arrow nav" })
vim.keymap.set("n", "<Down>", "", { desc = "Disable arrow nav" })
vim.keymap.set("n", "<Left>", "", { desc = "Disable arrow nav" })
vim.keymap.set("n", "<Right>", "", { desc = "Disable arrow nav" })

-- backspace nav
vim.opt.backspace = { "indent", "eol", "start" }

-- terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- search
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear highlight" })
