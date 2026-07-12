return {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<Leader>g",
            mode = { "n", "x", "o" },
            function()
                require("flash").jump()
            end,
            desc = "Flash",
        },
        {
            "<Leader>G",
            mode = { "n", "x", "o" },
            function()
                require("flash").treesitter()
            end,
            desc = "Flash Treesitter",
        },
        {
            "<Leader>r",
            mode = "o",
            function()
                require("flash").remote()
            end,
            desc = "Remote Flash",
        },
        {
            "<Leader>R",
            mode = { "o", "x" },
            function()
                require("flash").treesitter_search()
            end,
            desc = "Treesitter Search",
        },
        {
            "<c-s>",
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
    opts = {},
    ---@diagnostic enable: missing-fields
}
