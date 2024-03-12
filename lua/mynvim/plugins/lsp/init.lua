-- mainly inspired by LazyVim LSP
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua

local function on_attach(handler)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            handler(client, buffer)
        end,
  })
end

return {
    -- cmdline tools and lsp servers
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = {
            { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" }
        },
        opts = {
            ensure_installed = require("mynvim.configs").install.mason,
            registries = {
                "lua:mynvim.mason.registry",
                "github:mason-org/mason-registry",
            },
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end,
    },

    -- Use Neovim as a language server to inject LSP features with arbitrary
    -- programs
    {
        "nvimtools/none-ls.nvim",
        event = "BufReadPre",
        dependencies = {
            "mason.nvim",
            "gbprod/none-ls-shellcheck.nvim",
        },
        opts = function()
            local nls = require("null-ls")

            local parse_dots = function (str)
                local keys = {}
                for key in str:gmatch "[^.]+" do
                    table.insert(keys, key)
                end
                return keys
            end

            local get_field = function (pkg, field)
                local obj = pkg
                local keys = parse_dots(field)
                for i = 2, #keys do
                    obj = obj[keys[i]]
                end

                return obj
            end

            local source_from_str = function (key)
                local nls_prefix = "nls."
                local null_ls_prefix = "null_ls."
                local field = ""
                local pkg = nil
                local pkg_end = key:find(":")

                if pkg_end ~= nil then
                    -- "x.y.z:a.b.c"
                    -- pkg = require("x.y.z")
                    -- field = "a.b.c"
                    pkg = require(key:sub(1, pkg_end - 1))
                    field = key:sub(pkg_end + 1)
                elseif key:sub(1, #nls_prefix) == nls_prefix or key:sub(1, #null_ls_prefix) == null_ls_prefix then
                    -- "nls.a.b.c" or "null_ls.a.b.c"
                    -- pkg = nls
                    -- field = "a.b.c"
                    pkg = nls
                    field = key:sub(key:find(".") + 1)
                else
                    -- "x.y.z.a.b.c"
                    -- pkg = "x.y.x.a.b.c"
                    -- field = nil
                    pkg = require(key)
                end
                if field == "" then
                    return pkg
                else
                    return get_field(pkg, field)
                end
            end

            local nls_installs = require("mynvim.configs").install.nls
            local source_config = {}
            for i = 1, #nls_installs  do
                local item = nls_installs[i]
                table.insert(source_config, source_from_str(item))
            end
            -- table.insert(source_config, require("none-ls-shellcheck.code_actions"))

            return {
                -- check the full list:
                --   https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
                sources = source_config,
            }
        end,
    },

    -- lspconfig
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
            { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = { spacing = 4, prefix = "●" },
                severity_sort = true,
            },

            -- options for vim.lsp.buf.format
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },

            -- LSP Server Settings
            servers = require("mynvim.configs").install.servers,

            setup = require("mynvim.configs").install.setup,
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)
            -- setup formatting and keymaps
            on_attach(function(client, buffer)
                require("mynvim.plugins.lsp.keymaps").on_attach(client, buffer)
            end)

            -- diagnostics
            for name, icon in pairs(require("mynvim.configs.icons").icons.diagnostics) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end
            vim.diagnostic.config(opts.diagnostics)

            local servers = opts.servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

            local function setup(server)
                local server_opts = servers[server] or {}
                server_opts.capabilities = capabilities
                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            local mlsp = require("mason-lspconfig")
            local available = mlsp.get_available_servers()

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(available, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
            require("mason-lspconfig").setup_handlers({ setup })
        end,
    },

    -- lsp symbol navigation for lualine
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = function()
            vim.g.navic_silence = true
            on_attach(function(client, buffer)
                if client.server_capabilities.documentSymbolProvider then
                    require("nvim-navic").attach(client, buffer)
                end
            end)
        end,
        opts = function()
            return {
                highlight = true,
                depth_limit = 5,
                icons = require("mynvim.configs").icons.kinds,
            }
        end,
    },

    -- A tree like view for symbols in Neovim using the LSP
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = {
            {"<F4>", function() vim.cmd("SymbolsOutline") end}
        },
        opts = {
            symbols = {
                -- override default icons which don't show correctly in my envs
                Field = { icon = "", hl = "@field" },
                Module = { icon = "", hl = "@namespace" },
            },
        },
    },
}
