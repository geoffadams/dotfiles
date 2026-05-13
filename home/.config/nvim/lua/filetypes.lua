local u = require("util")

vim.filetype.add({
    extension = {
        urls = function()
            return "urls", function()
                vim.opt_local.commentstring = "# %s"
            end
        end,
    },
    filename = {
        [".homesickrc"] = "ruby",
    },
    pattern = {
        [".*ya?ml"] = function(path, _)
            local ansible_markers = { "ansible.cfg", "inventory.ini", "inventory.yaml", "inventory.yml" }
            local stop_dir = vim.fs.normalize(vim.uv.cwd() .. "/.." or vim.uv.os_homedir() or vim.env.HOME)
            local ansible_marker_files =
                vim.fs.find(ansible_markers, { upward = true, type = "file", path = path, stop = stop_dir })

            return vim.tbl_isempty(ansible_marker_files) and "yaml" or "yaml.ansible"
        end,
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help" },
    callback = function(opts)
        u.keymap_buf("n", "gd", "<C-]>", "Go to definition", opts.buf)
    end,
})
