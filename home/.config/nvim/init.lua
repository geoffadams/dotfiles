vim.cmd("scriptencoding utf-8")

-- leader (early)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.exrc = true

-- lazy.nvim
require("config.lazy")

-- general behaviour
require("interface")
require("editor")
require("workspace")

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
