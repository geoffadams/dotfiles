local u = require("util")

-- undotree
vim.cmd("packadd nvim.undotree")
u.keymap("n", "<leader>vu", function()
    require("undotree").open({
        command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
    })
end, "Undotree toggle")

-- difftool
vim.cmd("packadd nvim.difftool")
