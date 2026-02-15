return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        spec = {
            { "<Leader>b", group = "buffer" },
            { "<Leader>c", group = "code" },
            { "<Leader>d", group = "debugger" },
            { "<Leader>h", group = "git hunks" },
            { "<Leader>o", group = "open/find" },
            { "<Leader>s", group = "search" },
            { "<Leader>t", group = "toggles" },
            { "<Leader>x", group = "diagnostics" },
        },
    },
}
