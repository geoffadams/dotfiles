return {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {},
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        log_level = "warn",
        legacy_cmds = false,
        session_lens = {
            picker = "fzf",
            load_on_setup = false,
            previewer = "summary",
        },
    },
    keys = {
        { "<Leader>sw", "<cmd>AutoSession search<CR>", desc = "Session search" },
    },
}
