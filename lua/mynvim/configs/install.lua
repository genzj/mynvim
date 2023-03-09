local defaults = {
    treesitter = {
        "bash",
        "help",
        "html",
        "javascript",
        "jq",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
    },

    -- It's recommended to install LSP servers with the `servers` table below.
    -- Utilities listed here are mainly for null-ls sources
    mason = {
        -- Lua
        "stylua",

        -- shell
        "shellcheck",
        "shfmt",
    },

    nls = {
        -- nls.builtins.formatting.prettierd,
        "nls.builtins.formatting.stylua",

        -- shell
        "nls.builtins.code_actions.shellcheck",
        "nls.builtins.formatting.shfmt",
    },

    servers = {
        jsonls = {},
        bashls = {},
        lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            settings = {
                Lua = {
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = {'vim'},
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                }
            }
        },
    },

    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
    },
}

return vim.tbl_deep_extend("force", defaults, vim.g.mynvim_install or {})
