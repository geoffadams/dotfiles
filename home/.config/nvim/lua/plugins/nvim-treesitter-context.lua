return {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    config = function()
        require("treesitter-context").setup({
            multiwindow = true,
        })
    end,
}
