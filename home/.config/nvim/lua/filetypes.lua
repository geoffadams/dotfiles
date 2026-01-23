-- .homesickrc
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = ".homesickrc",
    callback = function(args) vim.opt.filetype = "ruby" end
})

-- .json
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*.json",
    callback = function(args) vim.opt.filetype = "javascript" end
})