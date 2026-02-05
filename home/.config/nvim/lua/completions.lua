local util = require("util")
local completion = require("mini.completion")
local pairs = require("mini.pairs")
local mkeymap = require("mini.keymap")
local snippets = require("mini.snippets")
local icons = require("mini.icons")

icons.tweak_lsp_kind()
pairs.setup()
mkeymap.setup()

local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
completion.setup({
    lsp_completion = {
        auto_setup = false,
        -- Without this config autocompletion is set up through `:h 'completefunc'`.
        -- Although not needed, setting up through `:h 'omnifunc'` is cleaner
        -- (sets up only when needed) and makes it possible to use `<C-u>`.
        source_func = "omnifunc",
        process_items = function(items, base)
            -- Customize post-processing of LSP responses for a better user experience.
            -- Don't show 'Text' suggestions (usually noisy) and show snippets last.
            return completion.default_process_items(items, base, process_items_opts)
        end,
    },
})

-- Set 'omnifunc' for LSP completion only when needed.
function set_omnifunc(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
end
util.lsp_attach_autocmd(nil, set_omnifunc, "Set 'omnifunc'")

-- Navigate 'mini.completion' menu with `<Tab>` /  `<S-Tab>`
mkeymap.map_multistep("i", "<Tab>", { "pmenu_next" })
mkeymap.map_multistep("i", "<S-Tab>", { "pmenu_prev" })
mkeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
mkeymap.map_multistep("i", "<BS>", { "minipairs_bs" })

local config_path = vim.fn.stdpath("config")
snippets.setup({
    snippets = {
        -- Always load 'snippets/global.json' from config directory
        snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
    },
})

-- By default snippets available at cursor are not shown as candidates in
-- 'mini.completion' menu. This requires a dedicated in-process LSP server
-- that will provide them. To have that, uncomment next line (use `gcc`).
-- MiniSnippets.start_lsp_server()

-- Advertise to servers that Neovim now supports certain set of completion and
-- signature features through 'mini.completion'.
vim.lsp.config("*", { capabilities = completion.get_lsp_capabilities() })
