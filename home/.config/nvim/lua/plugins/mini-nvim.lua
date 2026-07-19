return {
    "nvim-mini/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
        local icons = require("mini.icons")
        icons.setup()
        icons.mock_nvim_web_devicons()
        icons.tweak_lsp_kind()
    end,
}
