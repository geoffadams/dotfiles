return {
    "claydugo/browsher.nvim",
    event = "VeryLazy",
    config = function()
        -- Specify empty to use below default options
        require("browsher").setup()
    end,
}
