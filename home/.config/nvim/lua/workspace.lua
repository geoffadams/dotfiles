require('mini.bufremove').setup()

require("fzf-lua").setup()
vim.api.nvim_set_keymap("n", "<C-o>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-?>", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-g>", [[<Cmd>lua require"fzf-lua".live_grep()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-f>", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], {})
vim.api.nvim_set_keymap("n", "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], {})

require("fzf-lua").utils.info(
  "|<C-o> buffers|<C-p> files|<C-f> grep|<C-g> live grep|<C-?> builtin|<F1> help|")
