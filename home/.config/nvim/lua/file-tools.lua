-- undotree
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>vu", function()
    require("undotree").open({
        command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
    })
end, { desc = "Undotree toggle" })

-- difftool
vim.cmd("packadd nvim.difftool")
