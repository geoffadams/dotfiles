vim.cmd("scriptencoding utf-8")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")

require("keymap")
require("workspace")

require("interface")
require("editor")
require("recovery")

require("lsp")
require("filetypes")

require("debugger")
