return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        spec = {
            { "<Leader>b", group = "buffer" },
            { "<Leader>c", group = "code" },
            { "<Leader>d", group = "debugger" },
            { "<Leader>h", group = "git hunks" },
            { "<Leader>f", group = "find/grep" },
            { "<Leader>t", group = "toggles" },
            { "<Leader>tv", group = "view toggles" },
            { "<Leader>tw", group = "wrapping toggles" },
        },
    },
}
