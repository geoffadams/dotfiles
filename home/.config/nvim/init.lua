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
require("pickers")
require("file-tools")
require("git")

-- development
require("installers")
require("treesitter")
require("lsp")
require("formatters")
require("completions")
require("debuggers")

-- behaviour
require("keymap")
require("filetypes")
