return {
    "ibhagwan/fzf-lua",
    lazy = true,
    dependencies = { "nvim-mini/mini.nvim" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {
        winopts = {
            preview = { default = "bat_native" },
        },
        defaults = {
            formatter = "path.filename_first",
            git_icons = true,
        },
        buffers = {
            winopts = {
                preview = {
                    hidden = true,
                },
            },
        },
        grep = {
            RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
        },
        lsp = {
            finder = {
                winopts = {
                    height = 0.5,
                    width = 0.5,
                    row = 0.5,
                    col = 0.5,
                    preview = {
                        vertical = "down:60%",
                        layout = "vertical",
                    },
                },
            },
            code_actions = {
                previewer = "codeaction_native",
                preview_pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
            },
        },
    },
    ---@diagnostic enable: missing-fields
    keys = {
        { "<C-p>", [[<Cmd>lua require"fzf-lua".global()<CR>]], desc = "Global picker" },
        { "<C-S-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], desc = "Files" },
        { "<C-M-p>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], desc = "Buffers" },
        { "<C-f>", [[<Cmd>lua require"fzf-lua".live_grep({resume = true})<CR>]], desc = "Live Grep" },

        { "<C-F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], desc = "Help tags" },
        { "<C-F2>", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], desc = "Pickers" },

        { "<C-a>", [[<Cmd>lua require"fzf-lua".lsp_code_actions()<CR>]], desc = "Code actions" },
        {
            "<C-l>",
            [[<Cmd>lua require"fzf-lua".lsp_finder()<CR>]],
            desc = "LSP definitions, declarations & references",
        },

        { "<C-,>", [[<Cmd>lua require"fzf-lua".lsp_document_symbols()<CR>]], desc = "Document symbols" },
        { "<C-S-,>", [[<Cmd>lua require"fzf-lua".lsp_workspace_symbols()<CR>]], desc = "Workspace symbols" },
        { "<C-.>", [[<Cmd>lua require"fzf-lua".lsp_document_diagnostics()<CR>]], desc = "Document diagnostics" },
        { "<C-S-.>", [[<Cmd>lua require"fzf-lua".lsp_workspace_diagnostics()<CR>]], desc = "Workspace diagnostics" },
        { "<C-\\>", [[<Cmd>lua require"fzf-lua".quickfix()<CR>]], desc = "Quickfix" },

        {
            "<C-S-g>",
            function()
                require("fzf-lua").combine({ pickers = { "git_branches", "git_tags", "git_stash" } })
            end,
            desc = "Git refs (branches, tags, stash)",
        },
    },
}
