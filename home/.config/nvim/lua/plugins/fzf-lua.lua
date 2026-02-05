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
        { "<C-p>", [[<Cmd>lua require"fzf-lua".global()<CR>]] },
        { "<Leader>ob", [[<Cmd>lua require"fzf-lua".buffers()<CR>]] },
        { "<Leader>oh", [[<Cmd>lua require"fzf-lua".builtin()<CR>]] },
        { "<Leader>op", [[<Cmd>lua require"fzf-lua".files()<CR>]] },
        { "<Leader>sd", [[<Cmd>lua require"fzf-lua".live_grep()<CR>]] },
        { "<Leader>ss", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]] },
        { "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]] },
    },
}
