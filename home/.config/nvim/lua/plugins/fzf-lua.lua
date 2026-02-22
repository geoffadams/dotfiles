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
        { "<Leader>fg", [[<Cmd>lua require"fzf-lua".files()<CR>]], desc = "Files" },
        { "<Leader>fb", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], desc = "Buffers" },
        { "<Leader>ff", [[<Cmd>lua require"fzf-lua".live_grep_glob()<CR>]], desc = "Grep" },
        { "<Leader>fq", [[<Cmd>lua require"fzf-lua".quickfix()<CR>]], desc = "Quickfix" },
        { "<Leader>fa", [[<Cmd>lua require"fzf-lua".lsp_code_actions()<CR>]], desc = "Code actions" },
        {
            "<Leader>fd",
            [[<Cmd>lua require"fzf-lua".lsp_finder()<CR>]],
            desc = "LSP definitions, declarations & references",
        },
        { "<Leader>fs", [[<Cmd>lua require"fzf-lua".lsp_document_symbols()<CR>]], desc = "Document symbols" },
        { "<Leader>fS", [[<Cmd>lua require"fzf-lua".lsp_workspace_symbols()<CR>]], desc = "Workspace symbols" },
        { "<Leader>fx", [[<Cmd>lua require"fzf-lua".lsp_document_diagnostics()<CR>]], desc = "Document diagnostics" },
        { "<Leader>fX", [[<Cmd>lua require"fzf-lua".lsp_workspace_diagnostics()<CR>]], desc = "Workspace diagnostics" },
        { "<Leader>fc", [[<Cmd>lua require"fzf-lua".git_status()<CR>]], desc = "Git changes" },
        {
            "<Leader>fv",
            function()
                require("fzf-lua").combine({ pickers = "git_branches;git_tags;git_stash" })
            end,
            desc = "Git refs (branches, tags, stash)",
        },
        { "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], desc = "Help tags" },
        { "<Leader>f?", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], desc = "Pickers" },
    },
}
