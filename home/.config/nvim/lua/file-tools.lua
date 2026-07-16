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

-- canola
vim.g.canola = {
    columns = { "git_status", "icon", "permissions" },
    watch = true,
    keymaps = {
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<C-t>"] = false,
        ["<C-CR>"] = { callback = "actions.select", opts = { vertical = true } },
        ["<C-p>"] = "actions.preview",
    },
    float = {
        default = true,
        max_width = 0.8,
        max_height = 0.5,
    },
}
vim.g.canola_git = {}
