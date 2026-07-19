return {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
        { mode = { "n", "x", "o" }, "<Leader>g", [[<Cmd>lua require "flash".treesitter()<CR>]], desc = "Jump 🌳" },
        { mode = { "n", "x", "o" }, "<Leader>G", [[<Cmd>lua require "flash".treesitter()<CR>]], desc = "Jump" },
        { mode = { "c" }, "<C-s>", [[<Cmd>lua require("flash").toggle()<CR>]], desc = "Toggle Flash Search" },
    },
    ---@module "flash"
    ---@type Flash.Config
    ---@diagnostic disable: missing-fields
    opts = {
        label = {
            before = true,
            after = false,
            rainbow = {
                enabled = true,
            },
        },
        modes = {
            search = {
                enabled = true,
            },
            treesitter = {
                label = {
                    before = true,
                    after = false,
                },
                highlight = {
                    -- backdrop = true,
                    -- matches = true,
                },
            },
        },
    },
    ---@diagnostic enable: missing-fields
}
