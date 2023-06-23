return {
    -- better vim.notify
    {
        "rcarriga/nvim-notify",
        keys = function ()
            require('mynvim.utils').keymap.try_register({
                ["<leader>u"] = {name = "Notifications"},
            })
            return {
                {
                    "<leader>un",
                    function()
                        require("notify").dismiss({ silent = true, pending = true })
                    end,
                    desc = "Delete all Notifications",
                },
            }
        end,
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
    },
    -- noicer ui
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        enabled = require("mynvim.configs").switches.use_noice,
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
            },
        },
        -- stylua: ignore
        keys = function ()
            require('mynvim.utils').keymap.try_register({
                ["<leader>u"] = {name = "Notifications"},
            })
            return {
                { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
                { "<leader>ul", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
                { "<leader>uh", function() require("noice").cmd("history") end, desc = "Noice History" },
                { "<leader>ua", function() require("noice").cmd("all") end, desc = "Noice All" },
                { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward" },
                { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward"},
            }
        end,
    },
    -- LSP progress indicator without relying on Noice
    {
        "j-hui/fidget.nvim",
        branch = "legacy",
        config = true,
        event = "VeryLazy",
        enabled = not require("mynvim.configs").switches.use_noice,
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
                        require('bufferline').go_to_buffer(num)
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
                    local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                    .. (diag.warning and icons.Warn .. diag.warning or "")
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
        "Bekaboo/dropbar.nvim",
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
        event = "BufReadPre",
        keys = {
            { '<leader>og', '<Cmd>IndentBlanklineToggle!<CR>', desc="Toggle indent rule" },
        },
        opts = {
            -- char = "▏",
            char = "│",
            filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
            show_trailing_blankline_indent = false,
            show_current_context = true,
            show_current_context_start = true,
            use_treesitter_scope = false,
            -- char_highlight_list = { 'String', 'Function', 'Number', 'Special' },
            context_highlight_list = { 'Error' },
        },
    },

    -- ui components
    { "MunifTanjim/nui.nvim", lazy = true },
}
