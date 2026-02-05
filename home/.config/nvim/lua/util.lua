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

return M
