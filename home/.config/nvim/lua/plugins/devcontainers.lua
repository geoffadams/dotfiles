return {
    "jedrzejboczar/devcontainers.nvim",
    dependencies = {},
    event = "VeryLazy",
    config = function()
        require("devcontainers").setup({})

        -- nvim may already be running inside a devcontainer (e.g. via VS Code or SSH),
        -- so treat every dir as non-workspace to skip starting a container from within one.
        if vim.uv.fs_stat("/.dockerenv") then
            require("devcontainers.manager").is_workspace_dir = function()
                return false
            end
        end

        -- `devcontainer` CLI is installed into an nvm-managed node, so switch to the
        -- project's node version (or the default alias) before running any CLI command.
        local nvm_wrapper = [[
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
cd "$1" || exit 1
nvm use --silent 2>/dev/null || nvm use default --silent 2>/dev/null
shift
exec devcontainer "$@"
]]

        require("devcontainers.cli").register_cmd_override("nvm", function(workspace_dir, subcommand, ...)
            return {
                "bash",
                "-c",
                nvm_wrapper,
                "devcontainer-nvm",
                workspace_dir,
                subcommand,
                "--workspace-folder",
                workspace_dir,
                ...,
            }
        end)
    end,
}
