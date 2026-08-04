local M = {}

if vim.env.SSH_TTY ~= nil or vim.uv.fs_stat("/.dockerenv") then
    vim.notify("osc52 clipboard handler enabled", vim.log.levels.INFO)
    local osc52 = require("vim.ui.clipboard.osc52")

    -- "+"/"*" are provider-backed; getreg/setreg on them inside their own
    -- callback recurses and yields invalid data, so cache copies in Lua instead.
    local cache = {}

    local function copy_reg(reg)
        local orig = osc52.copy(reg)
        return function(lines, regtype)
            cache[reg] = { lines, regtype }
            orig(lines, regtype)
        end
    end

    local function paste_reg(reg)
        return function()
            local cached = cache[reg]
            if cached == nil then
                return {}, "v"
            end
            return cached[1], cached[2]
        end
    end

    local copy_providers = {
        ["+"] = copy_reg("+"),
        ["*"] = copy_reg("*"),
    }

    local write_only = {
        name = "OSC 52 (write-only)",
        copy = copy_providers,
        paste = {
            ["+"] = paste_reg("+"),
            ["*"] = paste_reg("*"),
        },
    }

    local full = {
        name = "OSC 52",
        copy = copy_providers,
        paste = {
            ["+"] = osc52.paste("+"),
            ["*"] = osc52.paste("*"),
        },
    }

    vim.g.clipboard = write_only

    local osc52_paste_enabled = false

    M.toggle_osc52_paste = function()
        osc52_paste_enabled = not osc52_paste_enabled
        vim.g.clipboard = osc52_paste_enabled and full or write_only

        -- The provider resolves g:clipboard into its own script-locals on first
        -- use and never re-reads it, so force it to pick up the new table.
        vim.g.loaded_clipboard_provider = nil
        vim.cmd("runtime autoload/provider/clipboard.vim")

        vim.notify(
            "osc52 paste " .. (osc52_paste_enabled and "enabled" or "disabled") .. " for this session",
            vim.log.levels.INFO
        )
    end
elseif vim.g.clipboard == nil then
    vim.notify("no clipboard handler enabled", vim.log.levels.WARN)
end
vim.opt.clipboard:append("unnamedplus")

return M
