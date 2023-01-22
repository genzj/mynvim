local icons = require("mynvim/configs/icons").icons

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
                statusline = false
            }
        },
    },

    -- easily jump to any location and enhanced f/t motions for Leap
    {
        "ggandor/leap.nvim",
        event = "VeryLazy",
        dependencies = { { "ggandor/flit.nvim", opts = { labeled_modes = "nv" } } },
        -- leap doesn't use `setup` but opts assignments
        config = function(_, opts)
            local leap = require("leap")
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
            leap.add_default_mappings(true)
        end,
    },
}
