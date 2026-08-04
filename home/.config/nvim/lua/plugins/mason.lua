return {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = {
        { "<Leader>st", "<Cmd>Mason<CR>", desc = "Mason" },
    },
    config = function()
        require("mason").setup()
    end,
}
