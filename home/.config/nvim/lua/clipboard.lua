-- clipboard
if vim.env.SSH_TTY ~= nil then
    vim.notify("osc52 enabled", vim.log.levels.INFO)
    local osc52 = require("vim.ui.clipboard.osc52")

    local function copy_reg(reg)
        local orig = osc52.copy(reg)
        return function(lines, regtype)
            -- Write to Vim's internal register
            vim.fn.setreg(reg, table.concat(lines, "\n"), regtype)

            -- Send OSC52 to local clipboard
            orig(lines, regtype)
        end
    end

    vim.g.clipboard = {
        name = "OSC 52 with register sync",
        copy = {
            ["+"] = copy_reg("+"),
            ["*"] = copy_reg("*"),
        },
        -- Do NOT use OSC52 paste, just use internal registers
        paste = {
            ["+"] = function()
                return vim.fn.getreg("+"), "v"
            end,
            ["*"] = function()
                return vim.fn.getreg("*"), "v"
            end,
        },
    }
else
    vim.notify("osc52 not enabled", vim.log.levels.INFO)
end
vim.opt.clipboard:append("unnamedplus")
