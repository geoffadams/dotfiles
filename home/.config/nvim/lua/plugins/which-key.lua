return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        spec = {
            { "<Leader>b", group = "buffer" },
            { "<Leader>c", group = "code" },
            { "<Leader>d", group = "debugger" },
            { "<Leader>h", group = "git hunks" },
            { "<Leader>f", group = "find/grep" },
            { "<Leader>t", group = "toggles" },
            { "<Leader>v", group = "view toggles" },
            { "<Leader>w", group = "wrapping" },
        },
    },
    keys = {
        {
            "<F1>",
            function()
                require("which-key").show()
            end,
            desc = "Keymaps",
        },
    },
}
