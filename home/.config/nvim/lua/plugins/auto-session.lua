return {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
        "ibhagwan/fzf-lua",
    },
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        legacy_cmds = false,
        session_lens = {
            picker = "fzf",
            load_on_setup = false,
            previewer = "summary",
        },
    },
    keys = {
        { "<leader>fp", "<cmd>AutoSession search<CR>", desc = "Session search" },
    },
}
