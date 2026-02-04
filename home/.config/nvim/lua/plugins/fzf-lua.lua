return {
    "ibhagwan/fzf-lua",
    lazy = true,
    -- optional for icon support
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    dependencies = { "nvim-mini/mini.nvim" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {},
    ---@diagnostic enable: missing-fields
    keys = {
        { "<C-o>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]] },
        { "<C-?>", [[<Cmd>lua require"fzf-lua".builtin()<CR>]] },
        { "<C-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]] },
        { "<C-g>", [[<Cmd>lua require"fzf-lua".live_grep()<CR>]] },
        { "<C-f>", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]] },
        { "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]] },
    },
}
