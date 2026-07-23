return {
    -- Bmessages.nvim better messages using an auto-updating buffer :Bmessages.
    {
        -- original repo was suspended, using a fork repo before its recovery
        -- "https://github.com/ariel-frischer/bmessages.nvim.git",
        "https://github.com/catgoose/bmessages.nvim",
        commit = "167d2a0",

        event = "CmdlineEnter",
        opts = {},
        keys = {
            {
                "<leader>ub",
                "<Cmd>Bmessages<CR>",
                desc = "Show messages",
            }
        },
    },
    -- LSP progress indicator + blanket vim.notify backend
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        keys = function()
            require("mynvim.utils").keymap.group("<leader>u", "Notifications")
            return {
                { "<leader>un", "<Cmd>Fidget clear<CR>", desc = "Dismiss Notifications" },
                {
                    "<leader>uh",
                    function()
                        require("telescope").load_extension("fidget")
                        require("telescope").extensions.fidget.fidget()
                    end,
                    desc = "Notification History (Telescope)",
                },
            }
        end,
        opts = {
            notification = {
                override_vim_notify = true,   -- fidget becomes the global vim.notify
                filter = vim.log.levels.INFO, -- minimum level to surface (fidget default)
            },
        },
    },
    -- better vim.ui
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    -- bufferline
    {
        "akinsho/nvim-bufferline.lua",
        event = "VeryLazy",
        init = function()
            local group = require("mynvim.utils").keymap.group
            vim.keymap.set("n", "<s-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
            vim.keymap.set("n", "<s-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
            group("<leader>b", "Bufferline & dropbar pick")
            vim.keymap.set("n", "<leader>bb", "<cmd>BufferLinePick<cr>", { desc = "Pick and Switch to a Buffer" })
            vim.keymap.set("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", { desc = "Pick and Close a Buffer" })
            for num = 1, 9 do
                vim.keymap.set(
                    "n",
                    "<leader>" .. num,
                    function ()
                        require('bufferline').go_to(num)
                    end,
                    { desc = "Go to buffer "..num }
                )
            end
        end,
        opts = {
            options = {
                numbers = "ordinal",
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                diagnostics_indicator = function(_, _, diag)
                    local icons = require("mynvim.configs.icons").icons.diagnostics
                    local ret = (diag.error and icons[vim.diagnostic.severity.ERROR] .. diag.error .. " " or "")
                    .. (diag.warning and icons[vim.diagnostic.severity.WARN] .. diag.warning or "")
                    return vim.trim(ret)
                end,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
    },

    {
        -- "Bekaboo/dropbar.nvim",

        -- https://github.com/Bekaboo/dropbar.nvim/pull/280
        "cubewhy/dropbar.nvim",
        branch = 'fix-event',
        event = {
            "BufWinEnter",
            "BufReadPost",
            "BufWritePost",
        },
        keys = {
            { "<leader>bd", function() require('dropbar.api').pick() end, desc = "Pick dropbar" }
        }
    },

    -- indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufReadPre",
        keys = {
            { '<leader>og', '<Cmd>IBLToggle<CR>', desc="Toggle indent rule" },
        },
        opts = {
            exclude = {
                filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
            },
            indent = {
                -- char = "▏",
                char = "│",
            },
            scope = {
                -- highlight = { 'String', 'Function', 'Number', 'Special' },
                highlight = { 'Error' },
                -- injected_languages = false,
            },
        },
    },

    -- ui components
    { "MunifTanjim/nui.nvim", lazy = true },
}
