local M = {}

local lsp_attach_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
M.lsp_attach_autocmd = function(pattern, callback, desc)
    local opts = { group = lsp_attach_group, pattern = pattern, callback = callback, desc = desc }
    vim.api.nvim_create_autocmd("LspAttach", opts)
end

local lsp_detach_group = vim.api.nvim_create_augroup("lsp-detach", { clear = true })
M.lsp_detach_autocmd = function(pattern, callback, desc)
    local opts = { group = lsp_detach_group, pattern = pattern, callback = callback, desc = desc }
    vim.api.nvim_create_autocmd("LspDetach", opts)
end

local lsp_highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
M.lsp_highlight_autocmd = function(event, buffer, callback, desc)
    local opts = { group = lsp_highlight_augroup, buffer = buffer, callback = callback, desc = desc }
    vim.api.nvim_create_autocmd(event, opts)
end

M.map_keys = function(from, mapping)
    local to = {}
    for k, v in pairs(from) do
        to[mapping[k]] = v
    end
    return to
end
M.map_vals = function(from, mapping)
    local to = {}
    for k, v in pairs(from) do
        to[k] = mapping(v)
    end
    return to
end

M.keymap = function(mode, l, r, desc)
    local opts = {
        desc = desc,
        noremap = true,
    }
    vim.keymap.set(mode, l, r, opts)
end

M.keymap_buf = function(mode, l, r, desc, bufnr)
    local opts = {
        desc = desc,
        buffer = bufnr,
        noremap = true,
    }
    vim.keymap.set(mode, l, r, opts)
end

M.on_very_lazy = function(callback)
    vim.api.nvim_create_autocmd("User", {
        pattern = { "VeryLazy" },
        callback = callback,
    })
end

M.get_venv_command = function(command)
    if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. "/bin/" .. command
    else
        return command
    end
end

return M
