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
        { "<C-p>", [[<Cmd>lua require"fzf-lua".global()<CR>]], desc = "Global picker" },
        { "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], desc = "Help tags" },
        { "<Leader>fb", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], desc = "Buffers" },
        { "<Leader>fc", [[<Cmd>lua require"fzf-lua".git_status()<CR>]], desc = "Git changes" },
        {
            "<Leader>fd",
            [[<Cmd>lua require"fzf-lua".lsp_finder()<CR>]],
            desc = "LSP definitions, declarations & references",
        },
        { "<Leader>ff", [[<Cmd>lua require"fzf-lua".files()<CR>]], desc = "Files" },
        { "<Leader>fg", [[<Cmd>lua require"fzf-lua".live_grep()<CR>]], desc = "Live grep" },
        { "<Leader>f?", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], desc = "Pickers" },
        { "<Leader>fs", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], desc = "Search project" },
        {
            "<Leader>fv",
            function()
                require("fzf-lua").combine({ pickers = "git_branches;git_tags;git_stash" })
            end,
            desc = "Git refs (branches, tags, stash)",
        },
        { "<Leader>fw", [[<Cmd>lua require"fzf-lua".lsp_workspace_symbols()<CR>]], desc = "Workspace symbols" },
    },
}
