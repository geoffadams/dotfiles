vim.diagnostic.config({
    float = {
        severity_sort = true,
        source = "if_many",
    },
    virtual_lines = {
        current_line = true,
    },
    virtual_text = false,
    underline = true,
    severity_sort = true,
    signs = {
        text = require("config/visual").icons.diagnostic,
        numhl = require("config/visual").highlight.diagnostic,
    },
})
