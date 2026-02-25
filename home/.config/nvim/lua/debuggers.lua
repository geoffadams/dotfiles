local dap = require("dap")

local function dap_configure()
    local function map(mode, lhs, rhs, desc)
        local opts = {
            desc = desc,
            noremap = true,
        }
        vim.keymap.set(mode, lhs, rhs, opts)
    end
    local dapui = require("dapui")
    dapui.setup()

    map("n", "<Leader>dr", function()
        dap.repl.toggle()
    end, "Open debug REPL")
    map("n", "<Leader>db", function()
        dap.toggle_breakpoint()
    end, "Toggle breakpoint")
    map("n", "<Leader>dX", function()
        dap.clear_breakpoints()
    end, "Clear all breakpoint")
    map("n", "<Leader>dp", function()
        dap.continue()
    end, "Continue execution")
    map("n", "<Leader>du", function()
        dap.run_to_cursor()
    end, "Run to cursor")
    map("n", "<Leader>dh", function()
        dap.step_out()
    end, "Step out")
    map("n", "<Leader>dj", function()
        dap.step_over()
    end, "Step over")
    map("n", "<Leader>dk", function()
        dap.restart_frame()
    end, "Restart frame")
    map("n", "<Leader>dl", function()
        dap.step_into()
    end, "Step into")

    map("n", "<Leader>td", function()
        dapui.toggle()
    end, "Toggle debugger UI")

    dapui.open()
end

local function dap_terminate()
    local dapui = require("dapui")
    dapui.close()
    vim.keymap.del("n", "<Leader>db")
    vim.keymap.del("n", "<Leader>do")
    vim.keymap.del("n", "<Leader>dh")
    vim.keymap.del("n", "<Leader>dj")
    vim.keymap.del("n", "<Leader>dk")
    vim.keymap.del("n", "<Leader>dl")
    vim.keymap.del("n", "<Leader>td")
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

vim.keymap.set("n", "<Leader>dv", function()
    require("osv").launch({ port = 8086 })
end, { noremap = true, desc = "Start Neovim debugger" })
vim.keymap.set("n", "<Leader>dp", function()
    dap.continue()
end, { noremap = true, desc = "Start debug session" })
