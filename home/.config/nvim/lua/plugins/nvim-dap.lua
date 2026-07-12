return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "jbyuki/one-small-step-for-vimkind",
    },
    lazy = true,
    config = function()
        local u = require("util")
        local dap = require("dap")

        dap.configurations.lua = {
            {
                type = "nlua",
                request = "attach",
                name = "Running Neovim instance",
            },
        }
        dap.adapters.nlua = function(callback, config)
            callback({
                type = "server",
                host = config.host or "127.0.0.1",
                port = config.port or 8086,
            })
        end

        local function dap_start_session(session)
            vim.notify(
                "Session "
                    .. session.config.request
                    .. ": "
                    .. session.config.name
                    .. " ("
                    .. session.adapter.host
                    .. ":"
                    .. session.adapter.port
                    .. ")"
            )

            u.keymap("n", "<Leader>dq", function()
                vim.notify("Disconnecting session...")
                require("dap").disconnect({}, function()
                    vim.notify("Session disconnected")
                    dap.close()
                end)
            end, "Disconnect session")

            u.keymap("n", "<Leader>dQ", function()
                vim.notify("Terminating session...")
                require("dap").terminate()
            end, "Terminate session")

            u.keymap("n", "<Leader>dr", function()
                dap.repl.toggle()
            end, "REPL")

            u.keymap("n", "<Leader>db", function()
                dap.toggle_breakpoint()
            end, "Toggle breakpoint")
            u.keymap("n", "<Leader>dX", function()
                dap.clear_breakpoints()
            end, "Clear all breakpoints")

            u.keymap("n", "<Leader>du", function()
                dap.run_to_cursor()
            end, "Run to cursor")
            u.keymap("n", "<Leader>dy", function()
                dap.restart_frame()
            end, "Restart frame")

            u.keymap("n", "<Leader>dh", function()
                dap.step_out()
            end, "Step out")
            u.keymap("n", "<Leader>dj", function()
                dap.step_over()
            end, "Step over")
            u.keymap("n", "<Leader>dk", function()
                dap.continue()
            end, "Continue")
            u.keymap("n", "<Leader>dl", function()
                dap.step_into()
            end, "Step into")
        end

        local function dap_terminate_session()
            vim.notify("Session terminated")
            vim.keymap.del("n", "<Leader>dq")
            vim.keymap.del("n", "<Leader>dQ")

            vim.keymap.del("n", "<Leader>dr")

            vim.keymap.del("n", "<Leader>db")
            vim.keymap.del("n", "<Leader>dX")

            vim.keymap.del("n", "<Leader>du")
            vim.keymap.del("n", "<Leader>dy")

            vim.keymap.del("n", "<Leader>dh")
            vim.keymap.del("n", "<Leader>dj")
            vim.keymap.del("n", "<Leader>dk")
            vim.keymap.del("n", "<Leader>dl")
        end

        dap.listeners.before.attach.dap_configure = dap_start_session
        dap.listeners.before.launch.dap_configure = dap_start_session
        dap.listeners.before.event_terminated.dap_terminate = dap_terminate_session
        dap.listeners.before.event_exited.dap_terminate = dap_terminate_session
    end,
}
