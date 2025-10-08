local icons = require("mynvim.configs").icons

return {
    -- file explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        version = "~3",
        keys = {
            {
                "<F3>",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = require("mynvim.utils").get_root() })
                end,
                desc = "Explorer NeoTree (root dir)",
            },
        },
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
            if vim.fn.argc() == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        opts = {
            default_component_configs = {
                git_status = {
                    symbols = {
                        -- Change type
                        added = icons.git.added,
                        modified = icons.git.modified,
                        deleted = icons.git.removed,
                    }
                },
            },
            filesystem = {
                follow_current_file = true,
                hijack_netrw_behavior = "open_default"
            },
            source_selector = {
                winbar = true,
                statusline = false,
            }
        },
    },

    -- easily jump to any location and enhanced f/t motions for Leap
    {
        "ggandor/leap.nvim",
        event = "VeryLazy",
        dependencies = {
            -- vim-repeat is needed to make dot-repeat work with the flit.nvim
            { "tpope/vim-repeat", event = "VeryLazy" },
        },
        keys = {
            { "<leader>j" },
            { "<leader>k" },
        },
        -- leap doesn't use `setup` but opts assignments
        config = function(_, opts)
            local leap = require("leap")
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
            leap.add_default_mappings(true)

            local function leap_line(backward)
                require('leap').leap {
                    pattern = '$',
                    backward = backward,
                    inputlen = 0,
                    action = function (event)
                        local target_line = event.pos[1]
                        local current_line = vim.fn.getpos('.')[2]
                        vim.cmd('norm! ' .. math.abs(target_line - current_line) .. (backward and 'k' or 'j'))
                    end
                }
            end
            vim.keymap.set({'n', 'x', 'o'}, '<leader>j', function () leap_line(false) end, {desc = "Leap Down Lines"})
            vim.keymap.set({'n', 'x', 'o'}, '<leader>k', function () leap_line(true) end, {desc = "Leap Up Lines"})

            -- 1-character search (enhanced f/t motions)
            -- ref: https://github.com/ggandor/leap.nvim/blob/f5fe479e20d809df7b54ad53142c2bdb0624c62a/README.md?plain=1#L695
            do
                -- Returns an argument table for `leap()`, tailored for f/t-motions.
                local function as_ft (key_specific_args)
                    local common_args = {
                        inputlen = 1,
                        inclusive = true,
                        -- To limit search scope to the current line:
                        -- pattern = function (pat) return '\\%.l'..pat end,
                        opts = {
                            labels = '',  -- force autojump
                            safe_labels = vim.fn.mode(1):match('o') and '' or nil,  -- [1]
                            case_sensitive = true,                                  -- [2]
                        },
                    }
                    return vim.tbl_deep_extend('keep', common_args, key_specific_args)
                end

                local clever = require('leap.user').with_traversal_keys       -- [3]
                local clever_f = clever('f', 'F')
                local clever_t = clever('t', 'T')

                for key, args in pairs {
                    f = { opts = clever_f, },
                    F = { backward = true, opts = clever_f },
                    t = { offset = -1, opts = clever_t },
                    T = { backward = true, offset = 1, opts = clever_t },
                } do
                    vim.keymap.set({'n', 'x', 'o'}, key, function ()
                        require('leap').leap(as_ft(args))
                    end)
                end
            end

            ------------------------------------------------------------------------
            -- [1] Match the modes here for which you don't want to use labels
            --     (`:h mode()`, `:h lua-pattern`).
            -- [2] For 1-char search, you might want to aim for precision instead of
            --     typing comfort, to get as many direct jumps as possible.
            -- [3] This helper function makes it easier to set "clever-f"-like
            --     functionality (https://github.com/rhysd/clever-f.vim), returning
            --     an `opts` table derived from the defaults, where:
            --     * the given keys are added to `keys.next_target` and
            --       `keys.prev_target`
            --     * the forward key is used as the first label in `safe_labels`
            --     * the backward (reverse) key is removed from `safe_labels`
        end,
    },

    -- references
    {
        "RRethy/vim-illuminate",
        event = "BufReadPost",
        opts = {
            delay = 300,
            modes_allowlist = { "n" },
            large_file_cutoff = 1000,
        },
        config = function(_, opts)
            require("illuminate").configure(opts)
        end,
        -- stylua: ignore
        keys = {
            -- { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
            -- { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
        },
    },

    -- better diagnostics list and others
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        opts = {
            focus = true,
        },
        keys = {
            { "<leader>a", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>A", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics (Trouble)" },
        },
    },

    -- highlight several words in different colors simultaneously
    {
        "inkarkat/vim-mark",
        cmd = { "Mark", "MarkClear" },
        dependencies = {
            { "inkarkat/vim-ingo-library" },
        },
        keys = {
            { "<Leader>m", desc="Toggle highlight", },
            { "<Leader>n", desc="Disable highlight", },
            { "<Leader>*", desc="Search highlight forward", },
            { "<Leader>#", desc="Search highlight backward", },
            { "<Leader>/", desc="Search all highlights forward", },
            { "<Leader>?", desc="Search all highlights backward", },
        },
    },

    -- better text-objects
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        -- Lazy load on key mapping doesn't work with which-key
        -- keys = {
        --     { "a", mode = { "x", "o" } },
        --     { "i", mode = { "x", "o" } },
        -- },
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                init = function()
                    -- no need to load the plugin, since we only need its queries
                    require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
                end,
            },
        },
        opts = function()
            local ai = require("mini.ai")
            return {
                search_method = 'cover',
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    F = ai.gen_spec.function_call(),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                },
            }
        end,
        config = function(_, opts)
            require('mynvim.utils').keymap.try_add(
                {
                    {
                        mode = { "o" },
                        { "a?", desc = "User prompt (mini.ai)" },
                        { "aF", desc = "Function call (mini.ai)" },
                        { "aa", desc = "Argument (mini.ai)" },
                        { "ab", desc = "Alias for ), ], } (mini.ai)" },
                        { "ac", desc = "Class (mini.ai)" },
                        { "af", desc = "Function (mini.ai)" },
                        { "ao", desc = "Block/Condition/Loop (mini.ai)" },
                        { "aq", desc = "Alias for \", ', ` (mini.ai)" },
                        { "at", desc = "Tag (mini.ai)" },
                        { "i?", desc = "User prompt (mini.ai)" },
                        { "iF", desc = "Function call (mini.ai)" },
                        { "ia", desc = "Argument (mini.ai)" },
                        { "ib", desc = "Alias for ), ], } (mini.ai)" },
                        { "ic", desc = "Class (mini.ai)" },
                        { "if", desc = "Function (mini.ai)" },
                        { "io", desc = "Block/Condition/Loop (mini.ai)" },
                        { "iq", desc = "Alias for \", ', ` (mini.ai)" },
                        { "it", desc = "Tag (mini.ai)" },
                    },
                }
            )
            local ai = require("mini.ai")
            ai.setup(opts)
        end,
    },
    {
        'tzachar/highlight-undo.nvim',
        keys = {
            { 'u', desc = "Undo with highlight-undo" },
            { '<C-r>', desc = "Redo with highlight-undo" },
        },
        opts = {
            duration = 500,
        },
    },
    {
        'mcauley-penney/visual-whitespace.nvim',
        event = 'VeryLazy',
        config = true
    },
    {
        'tpope/vim-eunuch',
        cmd = {
            'Remove',
            'Delete',
            'Move',
            'Mkdir',
            'SudoWrite',
            'SudoEdit',
        },
    },

    -- Use ripgrep for substitution
    {
        "chrisgrieser/nvim-rip-substitute",
        cmd = "RipSubstitute",
        keys = {
            {
                "<leader>f",
                function() require("rip-substitute").sub() end,
                mode = { "n", "x" },
                desc = " rip substitute",
            },
        },
    },
}
