local u = require("util")
local dap = require("dap")

local function dap_configure()
    local dapui = require("dapui")
    dapui.setup()

    u.keymap("n", "<Leader>dr", function()
        dap.repl.toggle()
    end, "Open debug REPL")
    u.keymap("n", "<Leader>db", function()
        dap.toggle_breakpoint()
    end, "Toggle breakpoint")
    u.keymap("n", "<Leader>dX", function()
        dap.clear_breakpoints()
    end, "Clear all breakpoint")
    u.keymap("n", "<Leader>du", function()
        dap.run_to_cursor()
    end, "Run to cursor")
    u.keymap("n", "<Leader>dh", function()
        dap.step_out()
    end, "Step out")
    u.keymap("n", "<Leader>dj", function()
        dap.step_over()
    end, "Step over")
    u.keymap("n", "<Leader>dk", function()
        dap.restart_frame()
    end, "Restart frame")
    u.keymap("n", "<Leader>dl", function()
        dap.step_into()
    end, "Step into")

    u.keymap("n", "<Leader>dU", function()
        dapui.toggle()
    end, "Toggle debugger UI")

    dapui.open()
end

local function dap_terminate()
    local dapui = require("dapui")
    dapui.close()
    vim.keymap.del("n", "<Leader>dr")
    vim.keymap.del("n", "<Leader>db")
    vim.keymap.del("n", "<Leader>dX")
    vim.keymap.del("n", "<Leader>du")
    vim.keymap.del("n", "<Leader>dh")
    vim.keymap.del("n", "<Leader>dj")
    vim.keymap.del("n", "<Leader>dk")
    vim.keymap.del("n", "<Leader>dl")
    vim.keymap.del("n", "<Leader>dU")
end

dap.listeners.before.attach.dap_configure = dap_configure
dap.listeners.before.launch.dap_configure = dap_configure
dap.listeners.before.event_terminated.dap_terminate = dap_terminate
dap.listeners.before.event_exited.dap_terminate = dap_terminate

dap.configurations.lua = {
    {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
    },
}

dap.adapters.nlua = function(callback, config)
    callback({
        type = "server",
        host = config.host or "127.0.0.1",
        port = config.port or 8086,
    })
end

u.keymap("n", "<Leader>dv", function()
    require("osv").launch({ port = 8086 })
end, "Start internal neovim debugger")
u.keymap("n", "<Leader>dp", function()
    dap.continue()
end, "Start debug session")
