vim.filetype.add({
    extension = {
        urls = function()
            return "urls", function()
                vim.opt_local.commentstring = "# %s"
            end
        end,
    },
    filename = {
        [".homesickrc"] = "ruby",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "kdl" },
    callback = function()
        vim.treesitter.start()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help" },
    callback = function(opts)
        vim.keymap.set("n", "gd", "<C-]>", { silent = true, buffer = opts.buf })
    end,
})
