vim.cmd("scriptencoding utf-8")

require("global")

-- lazy.nvim
require("config.lazy")

-- editing
require("interface")
require("editor")
require("clipboard")
require("filetypes")

-- syntax
require("treesitter")
require("lsp")
require("completions")

-- tooling
require("diagnostics")
require("file-tools")
require("formatters")

-- keymaps
require("keymap")
