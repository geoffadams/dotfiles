return {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<Leader>g",
            mode = { "n", "x", "o" },
            function()
                require("flash").treesitter()
            end,
            desc = "Jump 🌳",
        },
        {
            "<Leader>G",
            mode = { "n", "x", "o" },
            function()
                require("flash").jump()
            end,
            desc = "Jump",
        },
        {
            "<C-s>",
            mode = { "c" },
            function()
                require("flash").toggle()
            end,
            desc = "Toggle Flash Search",
        },
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
