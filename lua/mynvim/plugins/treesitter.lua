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
        lazy = false,
        build = ":TSUpdate",
        event = {
            "BufReadPost",
            "BufWritePost",
        },
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
            -- TODO not working with new TS
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-/>",
                    node_incremental = "<C-/>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>",
                },
            },
            -- TODO migrate to the new TS
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
        config = function(_, opts)
            local ts = require("nvim-treesitter")
            ts.setup(opts)
            ts.install(require("mynvim.configs").install.treesitter)

            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            vim.opt.foldenable = false

            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

            vim.g.rainbow_delimiters = {
                -- log = { level = vim.log.levels.TRACE },
            }

            -- TODO rainbow not working with the new TS
            -- the rainbow delimiters plugin will be disabled in vscode
            if require("mynvim.utils").get_plugin_by_name("rainbow-delimiters.nvim") ~= nil then
                require("rainbow-delimiters").enable(0)
            end
        end,
    },
}
