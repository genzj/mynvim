-- inspired by https://github.com/LazyVim/starter/blob/main/lua/config/lazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- import LazyVim plugins
    { import = "mynvim.plugins" },
    -- import/override with your plugins
    -- { import = "plugins" },
  },
  defaults = {
      lazy = true,
  },
  performance = {
      rtp = {
		-- do not reset rtp on win32 as I want to clone
		-- the configs to a different path instead of
		-- the default AppData config dir
        reset = (vim.fn.has('win32') == 0),
	  }
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
})
