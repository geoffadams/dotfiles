local M = {}

local wins = {}

---@param name string unique key identifying this floating window
---@param opts { lines: string[], highlights?: table[][], filetype?: string, title?: string }
function M.toggle(name, opts)
    local win = wins[name]
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
        wins[name] = nil
        return
    end

    local lines = opts.lines

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    if opts.highlights then
        local ns = vim.api.nvim_create_namespace("floating_history_" .. name)
        for line_idx, segments in ipairs(opts.highlights) do
            for _, segment in ipairs(segments) do
                local col_start, col_end, hl_group = segment[1], segment[2], segment[3]
                if hl_group then
                    vim.api.nvim_buf_set_extmark(buf, ns, line_idx - 1, col_start, {
                        end_col = col_end,
                        hl_group = hl_group,
                    })
                end
            end
        end
    end

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = opts.filetype or "floating-history"

    win = vim.api.nvim_open_win(buf, false, {
        relative = "editor",
        width = vim.o.columns,
        height = math.floor(vim.o.lines / 3),
        row = vim.o.lines - 2,
        col = 0,
        anchor = "SW",
        style = "minimal",
        border = "rounded",
        title = opts.title,
        title_pos = opts.title and "center" or nil,
        focusable = true,
    })

    vim.wo[win].scrolloff = 0
    vim.wo[win].wrap = false
    vim.api.nvim_win_set_cursor(win, { #lines, 0 })
    vim.api.nvim_win_call(win, function()
        vim.cmd("normal! zb")
    end)

    wins[name] = win
end

return M
