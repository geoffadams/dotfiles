-- nvim-dap
local dap = require("dap")

vim.keymap.set("n", "<Leader>db", require"dap".toggle_breakpoint, { noremap = true })
vim.keymap.set("n", "<Leader>dc", require"dap".continue, { noremap = true })
vim.keymap.set("n", "<Leader>do", require"dap".step_over, { noremap = true })
vim.keymap.set("n", "<Leader>di", require"dap".step_into, { noremap = true })

-- nvim-dap-ui
local dapui = require("dapui")
dapui.setup()

vim.keymap.set("n", "<Leader>dp", function()
  dapui.toggle()
end)

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- osv
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

vim.keymap.set("n", "<Leader>dv", function() 
  require"osv".launch({port = 8086}) 
end, { noremap = true })
