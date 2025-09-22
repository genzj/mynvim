-- ref: https://lazy.folke.io/installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
    end
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
    spec = {
        { import = "mynvim.plugins" },
    },
    defaults = {
        lazy = true,
        version = false,
        cond = require("mynvim.utils.vscode").filter_vscode_plugins,
    },
    performance = {
        rtp = {
            -- do not reset rtp on win32 as I want to clone
            -- the configs to a different path instead of
            -- the default AppData config dir
            reset = (vim.fn.has('win32') == 0),
        }
    },
    install = { colorscheme = { "bluloco" } },
    checker = {
        -- automatically check for plugin updates
        enabled = false,
        notify = false,
    },
    change_detection = {
        enabled = false,
    },
})
