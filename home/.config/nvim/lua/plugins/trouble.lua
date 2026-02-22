return {
    "folke/trouble.nvim",
    opts = {
        warn_no_results = false,
        open_no_results = true,
        modes = {
            major_diagnostics = {
                mode = "diagnostics", -- inherit from diagnostics mode
                filter = {
                    any = {
                        buf = 0, -- current buffer
                        {
                            severity = vim.diagnostic.severity.ERROR, -- errors only
                            -- filter out irrelevant diagnostics
                            function(item)
                                local inCurrentProject = item.filename:find(vim.uv.cwd(), 1, true)
                                local isNodeModules = item.filename:find("/node_modules/", 1, true)
                                return inCurrentProject and not isNodeModules
                            end,
                        },
                    },
                },
            },
        },
    },
    cmd = "Trouble",
    keys = {
        {
            "<Leader>td",
            "<Cmd>Trouble major_diagnostics toggle filter.buf=0<cr>",
            desc = "Document diagnostics",
        },
        {
            "<Leader>tD",
            "<Cmd>Trouble major_diagnostics toggle<cr>",
            desc = "Workspace diagnostics",
        },
        {
            "<Leader>ts",
            "<Cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Document symbols sidebar",
        },
        {
            "<Leader>tc",
            "<Cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP sidebar",
        },
        {
            "<Leader>tl",
            "<Cmd>Trouble loclist toggle<cr>",
            desc = "Location list",
        },
        {
            "<Leader>tq",
            "<Cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix list",
        },
    },
}
