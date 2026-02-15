local M = {}

---@class PrettyPath.Config
---@field path_home_rel? boolean
---@field path_cwd_rel? boolean
---@field keep_head? boolean
---@field keep_tail? boolean
---@field shorten_path_from? number
---@field shorten_segment_from? number
---@field shorten_to? number
---@field replace_with? string

---@type PrettyPath.Config
local default_config = {
    --- @type boolean
    path_home_rel = true, -- make the path home relative if possible
    --- @type boolean
    path_cwd_rel = true, -- make the path cwd relative if possible
    --- @type boolean
    keep_head = true, -- retain the first segment in full
    --- @type boolean
    keep_tail = true, -- retain the last segment in full
    --- @type number
    shorten_path_from = 30, -- min length of full path elligible for shortening
    --- @type number
    shorten_segment_from = 5, -- min length of path segments elligible for shortening
    --- @type number
    shorten_to = 2, -- number of characters to shorten to
    --- @type string
    replace_with = "…",
}

---@type PrettyPath.Config
M.config = {}

---@param opts? PrettyPath.Config
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", default_config, opts or {})
end

---@return string
function M.pretty_path()
    local path = vim.fn.expand("%:p")

    if not path or path == "" then
        return ""
    end

    local scheme_prefix = ""

    local fnamemodify_opts = ""
    if path:find("^term://.+") then
        _, _, scheme_prefix, path, _ = path:find("(term:)//(.+)//%d+:.+")
        fnamemodify_opts = ":."
    elseif path:find("^oil://") then
        _, _, scheme_prefix, path = path:find("(oil:)//(.*)")
        fnamemodify_opts = ":."
    else
        if M.config.path_home_rel then
            fnamemodify_opts = fnamemodify_opts .. ":~"
        end
        if M.config.path_cwd_rel then
            fnamemodify_opts = fnamemodify_opts .. ":."
        end
    end

    local path_prefix = ""
    local path_suffix = ""
    _, _, path_prefix, path, path_suffix, _ = path:find("(~?)(/?.+)(/?)")
    path = vim.fn.fnamemodify(path, fnamemodify_opts)

    if path == "" then
        path = "."
    end

    local shorten_practical_from = (M.config.shorten_to and M.config.shorten_to or 0) + #M.config.replace_with
    local length_cutoff =
        math.max(shorten_practical_from, M.config.shorten_segment_from and M.config.shorten_segment_from or 0)

    local function shorten(subpath, i, num_segments)
        if (M.config.keep_head and i == 1) or (M.config.keep_tail and i == num_segments) then
            return subpath
        end

        if M.config.shorten_to == 0 then
            return M.config.replace_with
        end

        if #subpath < length_cutoff then
            return subpath
        end

        return subpath:sub(1, M.config.shorten_to) .. M.config.replace_with
    end

    local out = path
    if #path > M.config.shorten_path_from then
        local segments = vim.split(path, "/", { plain = true })
        local shortened = {}
        for i, segment in ipairs(segments) do
            table.insert(shortened, shorten(segment, i, #segments))
        end
        out = table.concat(shortened, "/")
    end

    return scheme_prefix .. path_prefix .. out .. path_suffix
end

_G.PrettyPath = M
return M
