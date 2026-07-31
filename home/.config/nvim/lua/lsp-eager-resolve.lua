--- Some LSPs update text during completionItem/resolve, which certain completion
--- handlers don't refresh before inserting the completion. `vtsls` does this for
--- `completeFunctionCalls`, only providing the call snippet during resolve.
---
--- This monkey-patches the client with a wrapper for `textDocument/completion`,
--- eagerly resolving each completionItem and updating all insertion-relevant fields
--- _except_ the range, which remains the original.
---
--- To mitigate against the additional latency, eager resolution is limited to:
--- * items matching the base word
--- * methods and functions (see FUNC_KINDS)
--- * a maximum of MAX_RESOLVED_ITEMS items (default 50)
---

-- `CompletionItemKind`: 2 = Method, 3 = Function
local FUNC_KINDS = { [2] = true, [3] = true }

local MAX_RESOLVED_ITEMS = 50

--- Word being typed at the cursor, used to skip resolving irrelevant candidates.
---@return string
local function current_base()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    return line:sub(1, col):match("[%w_$]*$") or ""
end

---@param item table Completion item to test.
---@param base string Word being typed.
---@return boolean
local function should_resolve(item, base)
    if not FUNC_KINDS[item.kind] then
        return false
    end
    if base == "" then
        return true
    end
    local label = type(item.label) == "table" and item.label.label or item.label
    return type(label) == "string" and vim.startswith(label:lower(), base:lower())
end

---@param item table Item from `textDocument/completion` (mutated in place).
---@param resolved table Item from `completionItem/resolve`.
local function merge_resolved(item, resolved)
    item.insertText = resolved.insertText or item.insertText
    item.insertTextFormat = resolved.insertTextFormat or item.insertTextFormat
    item.additionalTextEdits = resolved.additionalTextEdits or item.additionalTextEdits
    item.detail = resolved.detail or item.detail
    item.documentation = resolved.documentation or item.documentation

    if type(resolved.textEdit) == "table" then
        if type(item.textEdit) == "table" then
            -- Keep the original ranges; only `newText` is meaningfully updated.
            item.textEdit.newText = resolved.textEdit.newText
        else
            item.textEdit = resolved.textEdit
        end
    end
end

--- Patch clients to eagerly resolve completions.
---@param client vim.lsp.Client
local function patch_client(client)
    if client.eager_resolve_patched then
        return
    end
    client.eager_resolve_patched = true

    local orig_request = client.request

    client.request = function(self, method, params, handler, bufnr)
        if method ~= "textDocument/completion" or handler == nil then
            return orig_request(self, method, params, handler, bufnr)
        end

        local function wrapped(err, result, ctx, config)
            local items = type(result) == "table" and (result.items or result) or nil
            if err or type(items) ~= "table" then
                return handler(err, result, ctx, config)
            end

            local base, todo = current_base(), {}
            for _, item in ipairs(items) do
                if should_resolve(item, base) then
                    todo[#todo + 1] = item
                    if #todo == MAX_RESOLVED_ITEMS then
                        break
                    end
                end
            end
            if #todo == 0 then
                return handler(err, result, ctx, config)
            end

            local pending = #todo
            local function done()
                pending = pending - 1
                if pending == 0 then
                    handler(err, result, ctx, config)
                end
            end

            for _, item in ipairs(todo) do
                local ok = orig_request(self, "completionItem/resolve", item, function(resolve_err, resolved)
                    if not resolve_err and type(resolved) == "table" then
                        merge_resolved(item, resolved)
                    end
                    done()
                end, bufnr)
                if not ok then
                    done()
                end
            end

            return true
        end

        return orig_request(self, method, params, wrapped, bufnr)
    end
end

return patch_client
