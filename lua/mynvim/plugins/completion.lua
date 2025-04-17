---@param kind string
---@return string|nil # the icon glyph or nil if kind isn't set
local function get_kind_icon(kind)
    local icons = require("mynvim.configs.icons").icons.kinds
    local text = icons[string.lower(kind)]
    if text then
        return text
    end
end

---@return boolean # true if the cursor follows a non space char
local has_words_before = function()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if col == 0 then
        return false
    end
    local line = vim.api.nvim_get_current_line()
    return line:sub(col, col):match("%s") == nil
end

---@type LazySpec[]
local M = {
    -- snippets
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        build = (function()
            -- Build Step is needed for regex support in snippets.
            -- This step is not supported in many windows environments.
            -- Remove the below condition to re-enable on windows.
            if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                return
            end
            return "make install_jsregexp"
        end)(),
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
    },

    -- auto pairs
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        config = function(_, opts)
            require("mini.pairs").setup(opts)
        end,
    },

    -- split and join
    {
        "echasnovski/mini.splitjoin",
        keys = {
            { "gS", desc = "Split/join" },
        },
        -- must require the lib manually, or 'mini' lib will be required
        config = function(_, opts)
            require("mini.splitjoin").setup(opts)
        end,
    },

    -- surround
    {
        "echasnovski/mini.surround",
        keys = function(plugin, keys)
            -- Populate the keys based on the user's options
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            require("mynvim.utils").keymap.group("<leader>s", "Surrounding")
            local mappings = {
                { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
                { opts.mappings.delete, desc = "Delete surrounding" },
                { opts.mappings.find, desc = "Find right surrounding" },
                { opts.mappings.find_left, desc = "Find left surrounding" },
                { opts.mappings.highlight, desc = "Highlight surrounding" },
                { opts.mappings.replace, desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
            }
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = "<leader>sa", -- Add surrounding in Normal and Visual modes
                delete = "<leader>sd", -- Delete surrounding
                find = "<leader>sf", -- Find surrounding (to the right)
                find_left = "<leader>sF", -- Find surrounding (to the left)
                highlight = "<leader>sh", -- Highlight surrounding
                replace = "<leader>sr", -- Replace surrounding
                update_n_lines = "<leader>sn", -- Update `n_lines`
            },
        },
        config = function(_, opts)
            -- use gz mappings instead of s to prevent conflict with leap
            require("mini.surround").setup(opts)
        end,
    },

    -- comments
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        config = function()
            require("ts_context_commentstring").setup({
                -- disable autocmd to use mini.comment
                enable_autocmd = false,
            })
        end,
    },
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        keys = {
            -- default mappings
            { "gc" }, -- Toggle comment (like `gcip` - comment inner paragraph) for both normal and visual modes
            { "gcc" }, -- Toggle comment on current line

            { "<D-/>", "gcc", desc = "Toggle comment", remap = true, mode = { "n" } }, -- VSCode style shortcut
            { "<D-/>", "gc", desc = "Toggle comment", remap = true, mode = { "v" } }, -- VSCode style shortcut
            { "<leader>c<space>", "gcc", desc = "Toggle comment", remap = true, mode = { "n" } }, -- VIM style shortcut
            { "<leader>c<space>", "gc", desc = "Toggle comment", remap = true, mode = { "v" } }, -- VIM style shortcut
        },
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
                end,
            },
        },
        config = function(_, opts)
            require("mini.comment").setup(opts)
        end,
    },
}

---@type LazySpec[]
local nvim_cmp_spec = {
    -- auto completion
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-Space>"] = cmp.mapping.complete({}),

                    -- Super-Tab like mapping
                    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                            -- they way you will only jump inside the snippet region
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<C-e>"] = cmp.mapping.abort(),
                    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { -- optional cmp completion source for require statements and module annotations
                        name = "lazydev",
                        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                    },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    format = function(_, item)
                        local icon = get_kind_icon(item.kind)
                        if icon then
                            item.kind = icon .. item.kind
                        end
                        return item
                    end,
                },
                experimental = {
                    ghost_text = {
                        hl_group = "LspCodeLens",
                    },
                    native_menu = false,
                },
            }
        end,
    },
}

---@type LazySpec[]
local blink_cmp_spec = {
    {
        -- Autocompletion
        "saghen/blink.cmp",
        event = "VimEnter",
        version = "1.*",
        dependencies = {
            "folke/lazydev.nvim",
            "L3MON4D3/LuaSnip",
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                -- 'default' (recommended) for mappings similar to built-in completions
                --   <c-y> to accept ([y]es) the completion.
                --    This will auto-import if your LSP supports it.
                --    This will expand snippets if the LSP sent a snippet.
                -- 'super-tab' for tab to accept
                -- 'enter' for enter to accept
                -- 'none' for no mappings
                --
                -- For an understanding of why the 'default' preset is recommended,
                -- you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                --
                -- All presets have the following mappings:
                -- <tab>/<s-tab>: move to right/left of your snippet expansion
                -- <c-space>: Open menu or open docs if already open
                -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
                -- <c-e>: Hide menu
                -- <c-k>: Toggle signature help
                --
                -- See :h blink-cmp-config-keymap for defining your own keymap

                -- https://cmp.saghen.dev/configuration/keymap.html#super-tab
                preset = "super-tab",

                ["<CR>"] = { "accept", "fallback" },
                ["<C-/>"] = { "show", "show_documentation", "hide_documentation" },
                ["<Tab>"] = {
                    function(cmp)
                        if cmp.is_visible() then
                            return cmp.select_next()
                        elseif cmp.snippet_active() then
                            return cmp.snippet_forward()
                        elseif has_words_before() then
                            return cmp.show()
                        end
                    end,
                    "fallback",
                },
                ["<S-Tab>"] = {
                    function(cmp)
                        if cmp.is_visible() then
                            return cmp.select_prev()
                        elseif cmp.snippet_active() then
                            return cmp.snippet_backward()
                        end
                    end,
                    "fallback",
                },

                -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
            },

            completion = {
                trigger = {
                    -- disable to avoid unnecessary requests
                    prefetch_on_insert = false,
                },

                -- By default, you may press `<c-space>` or `<c-/>` to show the documentation.
                -- Optionally, set `auto_show = true` to show the documentation after a delay.
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 1500,
                },
                menu = {
                    draw = {
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    return get_kind_icon(ctx.kind) .. ctx.icon_gap
                                end,
                            },
                        },
                    },
                },
            },

            sources = {
                default = { "lsp", "path", "snippets", "lazydev" },
                providers = {
                    -- TODO: add minuet-ai: https://github.com/milanglacier/minuet-ai.nvim?tab=readme-ov-file#blink-cmp-setup
                    lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
                },
            },

            snippets = { preset = "luasnip" },

            -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
            -- which automatically downloads a prebuilt binary when enabled.
            --
            -- By default, we enable it. You can also switch to the Lua implementation
            -- via `'lua'`
            --
            -- See :h blink-cmp-config-fuzzy for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },

            -- Shows a signature help window while you type arguments for a function
            signature = { enabled = true },
        },
    },
}

local function init()
    local cmp_provider = require("mynvim.configs.switches").cmp_provider
    if cmp_provider == "nvim-cmp" then
        vim.list_extend(M, nvim_cmp_spec)
    elseif cmp_provider == "blink.cmp" then
        vim.list_extend(M, blink_cmp_spec)
    else
        vim.notify_once("unsupported completion provider: " .. cmp_provider)
    end
end

init()

return M
