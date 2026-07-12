return {
    "claydugo/browsher.nvim",
    keys = {
        { mode = "n", "<leader>hl", "<cmd>Browsher commit<CR>", desc = "Open commit permalink" },
        { mode = "v", "<leader>hl", ":'<,'>Browsher commit<CR>gv", desc = "Open selection permalink" },
    },
    config = function()
        -- Specify empty to use below default options
        require("browsher").setup()
    end,
}
