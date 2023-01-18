-- follow the suggestions from
--  https://github.com/folke/lazy.nvim#-colorschemes
-- making the main colorscheme's lazy=false
return {
  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "storm" },
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },
}
