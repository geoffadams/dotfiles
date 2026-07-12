return {
    "jbyuki/one-small-step-for-vimkind",
    keys = {
        {
            "<Leader>dv",
            function()
                require("osv").launch({ port = 8086 })
            end,
            desc = "Start internal neovim debugger",
        },
    },
}
