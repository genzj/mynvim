local Util = require("mynvim.utils")

return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
        keys = function ()
            require('which-key').register({
                [ "<leader>t" ] = {
                    name="Telescope",
                    f = { name = "File" },
                    g = { name = "Git" },
                    s = { name = "Search" },
                },
            })
            return {
                { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
                { "<leader>/", Util.telescope("live_grep"), desc = "Find in Files (Grep)" },
                { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
                { "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
                -- find
                { "<leader>tfb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
                { "<leader>tff", Util.telescope("files"), desc = "Find Files (root dir)" },
                { "<leader>tfF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
                { "<leader>tfr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
                -- git
                { "<leader>tgc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
                { "<leader>tgs", "<cmd>Telescope git_status<CR>", desc = "status" },
                -- search
                { "<leader>tsa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
                { "<leader>tsb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
                { "<leader>tsc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
                { "<leader>tsC", "<cmd>Telescope commands<cr>", desc = "Commands" },
                { "<leader>tsd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
                { "<leader>tsg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
                { "<leader>tsG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
                { "<leader>tsh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
                { "<leader>tsH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
                { "<leader>tsk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
                { "<leader>tsM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
                { "<leader>tsm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
                { "<leader>tso", "<cmd>Telescope vim_options<cr>", desc = "Options" },
                { "<leader>tsR", "<cmd>Telescope resume<cr>", desc = "Resume" },
                { "<leader>tsw", Util.telescope("grep_string"), desc = "Word (root dir)" },
                { "<leader>tsW", Util.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
                {
                    "<leader>tss",
                    Util.telescope("lsp_document_symbols", {
                        symbols = {
                            "Class",
                            "Function",
                            "Method",
                            "Constructor",
                            "Interface",
                            "Module",
                            "Struct",
                            "Trait",
                            "Field",
                            "Property",
                        },
                    }),
                    desc = "Goto Symbol",
                },
                {
                    "<leader>tsS",
                    Util.telescope("lsp_workspace_symbols", {
                        symbols = {
                            "Class",
                            "Function",
                            "Method",
                            "Constructor",
                            "Interface",
                            "Module",
                            "Struct",
                            "Trait",
                            "Field",
                            "Property",
                        },
                    }),
                    desc = "Goto Symbol (Workspace)",
                },
                {
                    "<leader>tC",
                    Util.telescope("colorscheme", { enable_preview = true }),
                    desc = "Colorscheme with preview",
                },
            }
        end,
		opts = {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				mappings = {
					i = {
						["<c-t>"] = function(...)
							return require("trouble.providers.telescope").open_with_trouble(...)
						end,
						["<a-t>"] = function(...)
							return require("trouble.providers.telescope").open_selected_with_trouble(...)
						end,
						["<a-i>"] = function()
							Util.telescope("find_files", { no_ignore = true })()
						end,
						["<a-h>"] = function()
							Util.telescope("find_files", { hidden = true })()
						end,
						["<C-Down>"] = function(...)
							return require("telescope.actions").cycle_history_next(...)
						end,
						["<C-Up>"] = function(...)
							return require("telescope.actions").cycle_history_prev(...)
						end,
						["<C-f>"] = function(...)
							return require("telescope.actions").preview_scrolling_down(...)
						end,
						["<C-b>"] = function(...)
							return require("telescope.actions").preview_scrolling_up(...)
						end,
					},
					n = {
						["q"] = function(...)
							return require("telescope.actions").close(...)
						end,
					},
				},
			},
		},
	},
}
