return {
    "kokusenz/deltaview.nvim",
    dependencies = {
        "geoffadams/delta.lua",
    },
    opts = {
        line_numbers = true,
        keyconfig = {
            dm_toggle_keybind = "<C-g>",
            dv_toggle_keybind = "<C-A-g>",
        },
    },
}
