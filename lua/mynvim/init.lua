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


local vscode_plugins = {
      "flit.nvim",
      "lazy.nvim",
      "leap.nvim",
      "mini.ai",
      "mini.comment",
      "mini.pairs",
      "mini.surround",
      "nvim-treesitter",
      "nvim-treesitter-textobjects",
      "nvim-ts-context-commentstring",
      "vim-repeat",
}

---@param spec LazyPlugin
local function filter_vscode_plugins(spec)
    if vim.g.vscode then
        for _, value in ipairs(vscode_plugins) do
            if spec.name == value or spec.url:find(value .. "$") or spec.url:find(value .. ".git$") then
                return true
            end
        end
        return false
    else
        return true
    end
end

require("lazy").setup({
    spec = {
        { import = "mynvim.plugins" },
    },
    defaults = {
        lazy = true,
        version = false,
        cond = filter_vscode_plugins,
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
