local M = {}

function M.toggle()
    local lines = vim.split(vim.fn.execute("messages"), "\n", { plain = true })
    if lines[1] == "" then
        table.remove(lines, 1)
    end
    if #lines == 0 then
        lines = { "No messages" }
    end

    require("floating-history").toggle("messages", {
        lines = lines,
        filetype = "messages-history",
        title = " Messages ",
    })
end

return M
