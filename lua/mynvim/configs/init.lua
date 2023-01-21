local M = {}

M.icons = require("mynvim.configs.icons").icons

function M.setup()
    -- inspired by the gh:LazyVim/LazyVim
    -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua#L81
    local group = vim.api.nvim_create_augroup("MyNVIMSetup", { clear = true })

    vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "VeryLazy",
        callback = function()
            require("mynvim.configs.postplugins")
        end,
    })

    if vim.fn.argc() == 0 then
        -- autocmds and keymaps can wait to load
        vim.api.nvim_create_autocmd("User", {
            group = group,
            pattern = "VeryLazy",
            callback = function()
                require("mynvim.configs.autocmds")
                require("mynvim.configs.keymaps")
            end,
        })
    else
        -- load them now so they affect the opened buffers
        require("mynvim.configs.autocmds")
        require("mynvim.configs.keymaps")
    end
end

function M.init()
    require("mynvim.configs.python")
    require("mynvim.configs.options")
end

return M
