---@module 'lazy.types'
---@type LazySpec[]
return {
    {
        -- rainbow-delimiters isn't a TS plugin but must work with TS.
        -- will be loaded from TS setup
        'HiPhish/rainbow-delimiters.nvim',
        lazy = true,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = "BufReadPost",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { "<c-/>", desc = "Init/Increment selection" },
            { "<bs>", desc = "Schrink selection", mode = "x" },
        },
        ---@type TSConfig
        ---@diagnostic disable-next-line
        opts = {
            ensure_installed = require("mynvim.configs").install.treesitter,
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-/>",
                    node_incremental = "<C-/>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>",
                },
            },
            highlight = {
                enable = true,
                -- disable slow treesitter highlight for large files
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                    return false
                end,
            },
        },
        ---@param opts TSConfig
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            vim.opt.foldenable = false
            require("rainbow-delimiters").enable(0)
        end,
    },
}
