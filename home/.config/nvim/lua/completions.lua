local util = require("util")

vim.opt.completeopt = { "fuzzy", "menuone", "noselect", "popup" }
vim.opt.complete = { ".", "w", "b", "u" }
vim.opt.autocomplete = false

local config_path = vim.fn.stdpath("config")
local snippets = require("mini.snippets")
snippets.setup({
    snippets = {
        snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
    },
    expand = {
        select = function(snips, insert)
            return snippets.default_select(snips, insert, { insert_single = false })
        end,
        insert = function(snip)
            return snippets.default_insert(snip, { insert_single = false })
        end,
    },
})

snippets.start_lsp_server()

local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
local completion = require("mini.completion")
completion.setup({
    lsp_completion = {
        auto_setup = false,
        source_func = "omnifunc",
        process_items = function(items, base)
            return completion.default_process_items(items, base, process_items_opts)
        end,
        snippet_insert = function(snip)
            return snippets.default_insert({ body = snip }, { insert_single = false })
        end,
    },
})

local function set_omnifunc(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
end
util.lsp_attach_autocmd(nil, set_omnifunc, "Set 'omnifunc'")

vim.lsp.config("*", { capabilities = completion.get_lsp_capabilities() })
