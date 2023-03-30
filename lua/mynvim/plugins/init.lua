require("mynvim.configs").init()
require("mynvim.configs").setup()

-- Return user-defined plugins
return require("mynvim.configs").install.plugins
