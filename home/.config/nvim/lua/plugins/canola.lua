return {
    "barrettruth/canola.nvim",
    branch = "canola",
    dependencies = {
        "nvim-mini/mini.nvim",
        "barrettruth/canola-collection",
    },
    cmd = "Canola",
    keys = {
        { "-", "<Cmd>Canola<CR>", desc = "Open parent directory" },
    },
}
