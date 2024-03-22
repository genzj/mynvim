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
            { "ggandor/flit.nvim", opts = { labeled_modes = "nv" } },
        },
        -- leap doesn't use `setup` but opts assignments
        config = function(_, opts)
            local leap = require("leap")
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
            leap.add_default_mappings(true)
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
        cmd = { "TroubleToggle", "Trouble" },
        opts = {
            use_diagnostic_signs = true,
        },
        keys = {
            { "<leader>a", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
            { "<leader>A", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
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
            require('mynvim.utils').keymap.try_register(
                {
                    ['ab'] = [[Alias for ), ], } (mini.ai)]],
                    ['ib'] = [[Alias for ), ], } (mini.ai)]],
                    ['aq'] = [[Alias for ", ', ` (mini.ai)]],
                    ['iq'] = [[Alias for ", ', ` (mini.ai)]],
                    ['a?'] = [[User prompt (mini.ai)]],
                    ['i?'] = [[User prompt (mini.ai)]],
                    ['aa'] = [[Argument (mini.ai)]],
                    ['ia'] = [[Argument (mini.ai)]],
                    ['at'] = [[Tag (mini.ai)]],
                    ['it'] = [[Tag (mini.ai)]],
                    ['af'] = [[Function (mini.ai)]],
                    ['if'] = [[Function (mini.ai)]],
                    ['aF'] = [[Function call (mini.ai)]],
                    ['iF'] = [[Function call (mini.ai)]],
                    ['ao'] = [[Block/Condition/Loop (mini.ai)]],
                    ['io'] = [[Block/Condition/Loop (mini.ai)]],
                    ['ac'] = [[Class (mini.ai)]],
                    ['ic'] = [[Class (mini.ai)]],
                },
                { mode = 'o', prefix = '' }
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
}
