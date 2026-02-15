return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-mini/mini.nvim" },
    lazy = false,
    ---@module "oil"
    ---@type oil.SetupOpts
    opts = {
        default_file_explorer = true,
        columns = { "icon" },
        view_options = {
            show_hidden = true,
        },
    },
    keys = {
        { "-", "<Cmd>Oil<CR>", desc = "Open parent directory" },
    },
}
