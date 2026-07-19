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
                { "<Leader>b", group = "buffer" },
                { "<Leader>d", group = "debugger" },
                { "<Leader>h", group = "git", icon = { cat = "filetype", name = "git" } },
                { "<Leader>f", group = "finders", icon = { cat = "filetype", name = "fzf" } },
                { "<Leader>s", group = "settings", icon = { cat = "default", name = "os" } },
                { "<Leader>t", group = "trouble", icon = { cat = "filetype", name = "trouble" } },
                { "<Leader>v", group = "view toggles" },
                { "<Leader>w", group = "wrapping", icon = "󰖶" },
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
        })
    end,
}
