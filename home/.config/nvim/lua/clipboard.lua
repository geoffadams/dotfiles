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

    vim.g.clipboard = {
        name = "OSC 52 with register sync",
        copy = {
            ["+"] = copy_reg("+"),
            ["*"] = copy_reg("*"),
        },
        -- Do NOT use OSC52 paste, just use the cached copy
        paste = {
            ["+"] = paste_reg("+"),
            ["*"] = paste_reg("*"),
        },
    }
elseif vim.g.clipboard == nil then
    vim.notify("no clipboard handler enabled", vim.log.levels.WARN)
end
vim.opt.clipboard:append("unnamedplus")
