local M = {}

local TS_WIDTH = 8
local GROUP_WIDTH = 14
local ANNOTE_WIDTH = 8

local function format_history_item(item)
    local ts = vim.fn.strftime("%H:%M:%S", item.last_updated)
    local group_name = item.group_name or ""
    local annote = item.annote or ""

    local ts_field = string.format("%-" .. TS_WIDTH .. "s", ts)
    local group_field = string.format("%-" .. GROUP_WIDTH .. "s", group_name)
    local annote_field = string.format("%-" .. ANNOTE_WIDTH .. "s", annote)

    local prefix = ts_field .. " " .. group_field .. " " .. annote_field .. " "
    local pad = string.rep(" ", #prefix)

    local first_line_hl = {
        { 0, #ts_field, "Comment" },
        { #ts_field + 1, #ts_field + 1 + #group_field, "Special" },
        { #prefix - #annote_field - 1, #prefix - 1, item.style },
    }

    local lines = {}
    local highlights = {}
    for i, msg_line in ipairs(vim.split(item.message, "\n", { plain = true })) do
        local line_prefix = i == 1 and prefix or pad
        table.insert(lines, line_prefix .. msg_line)
        local segments = i == 1 and vim.list_extend({}, first_line_hl) or {}
        table.insert(segments, { #line_prefix, #line_prefix + #msg_line, "MsgArea" })
        table.insert(highlights, segments)
    end
    return lines, highlights
end

function M.toggle()
    local history = require("fidget.notification").get_history()
    table.sort(history, function(a, b)
        return a.last_updated < b.last_updated
    end)

    local lines = {}
    local highlights = {}
    for _, item in ipairs(history) do
        local item_lines, item_highlights = format_history_item(item)
        vim.list_extend(lines, item_lines)
        vim.list_extend(highlights, item_highlights)
    end
    if #lines == 0 then
        lines = { "No notification history" }
        highlights = { {} }
    end

    require("floating-history").toggle("fidget-notifications", {
        lines = lines,
        highlights = highlights,
        filetype = "fidget-notification-history",
        title = " Notification History ",
    })
end

return M
