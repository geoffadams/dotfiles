vim.cmd("scriptencoding utf-8")

require("global")

-- lazy.nvim
require("config.lazy")

-- general behaviour
require("interface")
require("editor")

-- tooling
require("git")
require("installers")
require("treesitter")
require("language-servers")
require("formatters")
require("completions")
require("debuggers")

-- behaviour
require("keymap")
require("filetypes")
