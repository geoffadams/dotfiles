return {
    "andrewferrier/wrapping.nvim",
    dependencies = { "rickhowe/wrapwidth" },
    event = "VeryLazy",
    keys = {
        {
            mode = "n",
            "<Leader>ww",
            "<Plug>(wrapping-soft-wrap-mode) <bar> <Cmd>Wrapwidth!<cr>",
            desc = "Enable soft-wrapping",
        },
        { mode = "n", "<Leader>wW", "<Plug>(wrapping-hard-wrap-mode)", desc = "Enable hard-wrapping" },
    },
    opts = {
        create_keymaps = false,
        softener = { markdown = true },
    },
}
