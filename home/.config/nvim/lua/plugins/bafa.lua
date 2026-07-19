return {
    "mistweaverco/bafa.nvim",
    dependencies = { "nvim-mini/mini.nvim" },
    keys = {
        { mode = "n", "<Tab>", '<Cmd>lua require "bafa".toggle()<CR>', desc = "Switch buffers" },
    },
    opts = {
        ui = {
            render = {
                ---@param line BafaUiBufferLine
                custom_format_buffer_line = function(line)
                    return PrettyPath.pretty_path("#" .. line.number)
                end,
            },
            sort = {
                focus_alternate_buffer = true,
            },
            title = {
                text = " buffers ",
            },
        },
    },
}
