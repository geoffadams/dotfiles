return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "ibhagwan/fzf-lua",
    },
    keys = {
        {
            "<Leader>dp",
            "<Cmd>FzfLua dap_configurations<CR>",
            desc = "Connect session",
        },
    },
    config = function()
        local u = require("util")
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup()

        local function dapui_start_session()
            u.keymap("n", "<Leader>dU", function()
                dapui.toggle()
            end, "Toggle debugger UI")
            dapui.open()
        end

        local function dapui_terminate_session()
            dapui.close()
            vim.keymap.del("n", "<Leader>dU")
        end

        dap.listeners.before.attach.dapui_configure = dapui_start_session
        dap.listeners.before.launch.dapui_configure = dapui_start_session
        dap.listeners.before.disconnect.dapui_terminate = dapui_terminate_session
        dap.listeners.before.event_terminated.dapui_terminate = dapui_terminate_session
        dap.listeners.before.event_exited.dapui_terminate = dapui_terminate_session
    end,
}
