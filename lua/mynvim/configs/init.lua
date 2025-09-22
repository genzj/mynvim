local M = {}

M.icons = require("mynvim.configs.icons").icons
M.install = require("mynvim.configs.install")
M.switches = require("mynvim.configs.switches")

function M.setup()
    -- inspired by the gh:LazyVim/LazyVim
    -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua#L81
    local group = vim.api.nvim_create_augroup("MyNVIMSetup", { clear = true })
    local lazyloads = {
        "mynvim.configs.postplugins",
        "mynvim.configs.highlight",
        "mynvim.configs.vscode"
    }
    if vim.fn.argc() == 0 then
        lazyloads[#lazyloads+1] = "mynvim.configs.autocmds"
    else
        -- load them now so they affect the opened buffers
        require("mynvim.configs.autocmds")
    end
    lazyloads[#lazyloads+1] = "mynvim.configs.keymaps";

    vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "VeryLazy",
        callback = function()
            for _, lazyload in pairs(lazyloads) do
                require(lazyload)
            end
        end,
    })
end

function M.init()
    require("mynvim.configs.python")
    require("mynvim.configs.options")
    require("mynvim.configs.commands")
end

return M
