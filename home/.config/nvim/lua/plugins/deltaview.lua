return {
    "kokusenz/deltaview.nvim",
    cmd = {
        "Delta",
        "DeltaView",
        "DeltaMenu",
    },
    keys = {
        { "<Leader>hd", "<Cmd>DeltaView<CR>", desc = "View file diff" },
        { "<Leader>hD", "<Cmd>DeltaMenu<CR>", desc = "View repo diff" },
    },
    opts = {
        keyconfig = {
            dm_toggle_keybind = nil,
            dv_toggle_keybind = nil,
            d_toggle_keybind = nil,
        },
    },
    config = function()
        require("deltaview").setup()
        require("delta").setup()
    end,
}
