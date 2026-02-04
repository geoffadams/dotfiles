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
                            -- limit to files in the current project
                            function(item)
                                return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
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
            "<leader>xx",
            "<cmd>Trouble major_diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xX",
            "<cmd>Trouble major_diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>cs",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>cl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>xL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>xQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },
}
