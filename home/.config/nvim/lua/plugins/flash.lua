return {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
        {
            mode = { "n", "x", "o" },
            "<Leader>m",
            [[<Cmd>lua require"flash".jump()<CR>]],
            desc = "Flash",
        },
        {
            mode = { "n", "x", "o" },
            "<Leader>n",
            [[<Cmd>lua require"flash".treesitter()<CR>]],
            desc = "Treesitter Flash",
        },
        {
            mode = { "n", "x", "o" },
            "<Leader>,",
            [[<Cmd>lua require"flash".jump({ pattern = vim.fn.expand("<cword>") })<CR>]],
            desc = "Word Flash",
        },
        { mode = { "c" }, "<C-s>", [[<Cmd>lua require("flash").toggle()<CR>]], desc = "Toggle Flash Search" },
    },
    ---@module "flash"
    ---@type Flash.Config
    ---@diagnostic disable: missing-fields
    opts = {
        label = {
            before = true,
            after = true,
            rainbow = {
                enabled = true,
            },
        },
        modes = {
            treesitter = {
                label = {
                    before = true,
                    after = true,
                },
            },
        },
    },
    ---@diagnostic enable: missing-fields
}
