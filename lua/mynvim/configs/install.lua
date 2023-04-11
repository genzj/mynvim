local defaults = {
    treesitter = {
        "bash",
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
        "vimdoc",
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
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { 'vim' },
                    },
                    workspace = {
                        -- prevent repetitive popups
                        -- https://github.com/neovim/nvim-lspconfig/pull/2536#issuecomment-1491451976
                        checkThirdParty = false,
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

local function concatArray(a, b)
    a = a or {}
    b = b or {}
    local result = {}
    for i = 1, #a do
        result[#result + 1] = a[i]
    end
    for i = 1, #b do
        result[#result + 1] = b[i]
    end
    return result
end

local mynvim_install = vim.g.mynvim_install or {}
return {
    treesitter = concatArray(defaults.treesitter, mynvim_install.treesitter or {}),
    mason = concatArray(defaults.mason, mynvim_install.mason or {}),
    nls = concatArray(defaults.nls, mynvim_install.nls or {}),
    servers = vim.tbl_deep_extend("force", defaults.servers, mynvim_install.servers or {}),
    setup = vim.tbl_deep_extend("force", defaults.setup, mynvim_install.setup or {}),
    plugins = mynvim_install.plugins or {},
}
