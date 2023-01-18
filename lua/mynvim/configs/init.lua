local M = {}

function M.init()
    require("mynvim.configs.python")
    require("mynvim.configs.options")
    require("mynvim.configs.keymaps")
    require("mynvim.configs.autocmds")
end

return M
