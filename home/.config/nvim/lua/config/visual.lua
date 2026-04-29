local M = {}

local u = require('../util')
local severity_to_index = vim.diagnostic.severity
local diagnostic_icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    HINT = "",
}

M.icons = {
    diagnostic = u.map_keys(diagnostic_icons, severity_to_index),
    diagnostic_by_name = diagnostic_icons,
}

M.highlight = {
    diagnostic = {
        [severity_to_index.ERROR] = "DiagnosticVirtualTextError",
        [severity_to_index.WARN] = "DiagnosticVirtualTextWarn",
    },
}

return M
