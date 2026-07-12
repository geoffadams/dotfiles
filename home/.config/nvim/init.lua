vim.cmd("scriptencoding utf-8")

require("global")

-- lazy.nvim
require("config.lazy")

-- general behaviour
require("interface")
require("editor")
require("clipboard")
require("diagnostics")

-- general tools
require("file-tools")

-- development
require("treesitter")
require("lsp")
require("formatters")
require("completions")

-- behaviour
require("keymap")
require("filetypes")
