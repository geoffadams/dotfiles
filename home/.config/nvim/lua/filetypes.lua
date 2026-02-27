vim.filetype.add({
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
