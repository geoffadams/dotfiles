return {
    "folke/which-key.nvim",
    dependencies = { "nvim-mini/mini.nvim" },
    event = "VeryLazy",
    keys = {
        { "<F1>", [[<Cmd>lua require "which-key".show()<CR>]], desc = "Keymaps" },
    },
    config = function()
        require("which-key").setup({
            preset = "modern",
            spec = {
                { "<Leader>n", icon = { icon = " ", color = "cyan" } },
                { "<Leader>m", icon = { icon = "󰾹 ", color = "cyan" } },
                { "<Leader>,", icon = { icon = " ", color = "cyan" } },
                { "<Leader>f", group = "find", icon = { icon = " ", color = "yellow" } },
                { "<Leader>b", group = "buffer", icon = { icon = " ", color = "blue" } },
                { "<Leader>v", group = "view", icon = { icon = " ", color = "green" } },
                { "<Leader>d", group = "diagnostics" },
                { "<Leader>r", group = "lsp", icon = { icon = "󰅩 ", color = "orange" } },
                { "<Leader>h", group = "git", icon = { cat = "filetype", name = "git", color = "purple" } },
                { "<Leader>d", group = "debugger" },
                { "<Leader>w", group = "wrapping", icon = { icon = " ", color = "grey" } },
                { "<Leader>s", group = "settings", icon = { cat = "default", name = "os", color = "grey" } },
                { "<Leader>`", hidden = true },
            },
            icons = {
                rules = {
                    { pattern = "gitsigns", cat = "filetype", name = "git" },
                    { plugin = "deltaview.nvim", cat = "filetype", name = "git" },
                    { plugin = "browsher.nvim", cat = "filetype", name = "git" },
                },
            },
            replace = {
                desc = {
                    { "<gitsigns>", "" },
                },
            },
            sort = { "manual" },
        })
    end,
}
