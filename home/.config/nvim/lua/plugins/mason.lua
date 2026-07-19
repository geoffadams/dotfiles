return {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = {
        { "<Leader>sm", "<Cmd>Mason<CR>", desc = "Mason" },
    },
    config = function()
        require("mason").setup()
    end,
}
