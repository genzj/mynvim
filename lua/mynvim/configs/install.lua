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

    mason = {
        -- Lua
        "stylua",

        -- shell
        "shellcheck",
        "shfmt",
    },

    servers = {
        jsonls = {},
        sumneko_lua = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            settings = {
                Lua = {
                    workspace = {
                        checkThirdParty = false,
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                },
            },
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
