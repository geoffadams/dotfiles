return {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {
        notification = {
            override_vim_notify = true,
            window = {
                normal_hl = "FidgetNotify",
                winblend = 40,
                border = "rounded",
                tabstop = 2,
            },
        },
    },
}
