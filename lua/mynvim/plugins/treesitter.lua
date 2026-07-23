-- disable slow treesitter highlight for large files
local function is_file_large_than(buf, max_filesize)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
        return true
    end
    return false
end

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
        'shushtain/incselect.nvim',
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
            "shushtain/incselect.nvim",
        },
        keys = {
            { "<c-/>", desc = "Init/Increment selection" },
            { "<bs>", desc = "Shrink selection", mode = "x" },
            { "<Tab>", desc = "Next sibling node", mode = "x" },
            { "<S-Tab>", desc = "Prev sibling node", mode = "x" },
            { "<S-CR>", desc = "Child node", mode = "x" },
        },
        ---@type TSConfig
        ---@diagnostic disable-next-line
        opts = {
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
            local ts_config = require("mynvim.configs")
            local supported_ts = ts_config.install.treesitter
            local ts = require("nvim-treesitter")
            ts.setup(opts)
            ts.install(supported_ts)

            local supported_fts = {}
            -- Use a temporary table to track unique filetypes to avoid duplicates
            local seen_fts = {}

            for _, lang in ipairs(supported_ts) do
                -- get_filetypes returns a table (e.g., {"javascript", "javascriptreact"})
                local fts = vim.treesitter.language.get_filetypes(lang)

                if fts then
                    for _, ft in ipairs(fts) do
                        if not seen_fts[ft] then
                            table.insert(supported_fts, ft)
                            seen_fts[ft] = true
                        end
                    end
                end
            end

            local ts_config_grp = vim.api.nvim_create_augroup("MyVIMTSConfigGroup", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = ts_config_grp,
                pattern = supported_fts,
                callback = function(args)
                    if is_file_large_than(args.buf, 1024 * 1024) then
                        return
                    end

                    -- syntax highlighting, provided by Neovim
                    vim.treesitter.start(args.buf)

                    -- find all windows displaying this buffer and update window-local options
                    local windows = vim.fn.getbufinfo(args.buf)[1].windows
                    for _, win_id in ipairs(windows) do
                        -- folds, provided by Neovim
                        vim.api.nvim_set_option_value('foldmethod', 'expr', {win=win_id})
                        vim.api.nvim_set_option_value('foldexpr', 'v:lua.vim.treesitter.foldexpr()', {win=win_id})
                        vim.api.nvim_set_option_value('foldenable', false, {win=win_id})
                    end

                    -- indentation, provided by nvim-treesitter
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                    -- the rainbow delimiters plugin will be disabled in vscode
                    if require("mynvim.utils").get_plugin_by_name("rainbow-delimiters.nvim") ~= nil then
                        require("rainbow-delimiters").enable(0)
                    end

                    -- incremental selection
                    local incselect = require("incselect")
                    vim.keymap.set("n", "<c-/>", incselect.init, { buffer = args.buf })
                    vim.keymap.set("x", "<c-/>", incselect.parent, { buffer = args.buf })
                    vim.keymap.set("x", "<bs>", incselect.undo, { buffer = args.buf })
                    vim.keymap.set("x", "<Tab>", incselect.next, { buffer = args.buf })
                    vim.keymap.set("x", "<S-Tab>", incselect.prev, { buffer = args.buf })
                    vim.keymap.set("x", "<S-CR>", incselect.child, { buffer = args.buf })
                end,
            })

        end,
    },
}
