local blends = {
    rust = {
        treesitter = {
            "rust",
        },
        nls = {
            "nls.builtins.formatting.rustfmt",
        },
        servers = {
            ["rust_analyzer"] = {
                settings = {
                    ['rust-analyzer'] = {
                        imports = {
                            granularity = {
                                group = "module",
                            },
                            prefix = "self",
                        },
                        cargo = {
                            buildScripts = {
                                enable = true,
                            },
                        },
                        procMacro = {
                            enable = true
                        },
                    }
                },
            },
        },
    },
    python = {
        nls = {
            "null_ls.builtins.diagnostics.mypy",
            -- isortd is installed from local registry mynvim.mason.registry
            -- but haven't figured out how to run it as a daemon
            -- "null_ls.builtins.formatting.isortd",
            "null_ls.builtins.formatting.isort",
        },
        mason = {
            "isort",
            "mypy",
        },
        servers = {
            ["pylsp"] = {},
        },
    },
}

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

local function mergeConfig(origin, new)
    return {
        treesitter = concatArray(origin.treesitter or {}, new.treesitter or {}),
        mason = concatArray(origin.mason or {}, new.mason or {}),
        nls = concatArray(origin.nls or {}, new.nls or {}),
        servers = vim.tbl_deep_extend("force", origin.servers or {}, new.servers or {}),
        setup = vim.tbl_deep_extend("force", origin.setup or {}, new.setup or {}),
        plugins = concatArray(origin.plugins or {}, new.plugins or {}),
    }
end

local function blendInto(config, blendName)
    local blend = blends[blendName]
    if blend == nil then
        error("Unrecognized blend name '" .. blendName .. "'")
    end
    return mergeConfig(config, blend)
end

local function blendAll(config, blendNames)
    for _, blendName in ipairs(blendNames) do
        config = blendInto(config, blendName)
    end
    return config
end

local mynvim_install = vim.g.mynvim_install or {}
local config = mergeConfig(
    blendAll(defaults, mynvim_install.blends or {}),
    mynvim_install
)

-- Create a command to pretty print the config variable
vim.cmd('command! ShowInstallConfig lua= require("mynvim.configs.install")')

return config
