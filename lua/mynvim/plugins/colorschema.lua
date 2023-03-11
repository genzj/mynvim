-- follow the suggestions from
--  https://github.com/folke/lazy.nvim#-colorschemes
-- making the main colorscheme's lazy=false
return {
  -- tokyonight
  {
    "folke/tokyonight.nvim",
    opts = { style = "storm" },
    config = function (_, opts)
        require("tokyonight").setup(opts)
    end
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },

  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { 'rktjmp/lush.nvim' },
    opts = {
      -- bluoco colors are enabled in gui terminals per default.
      terminal = vim.fn.has("gui_running") == 1 or vim.g.gonvim_running == 1,
    },
    config = function (_, opts)
      -- bluloco doesn't set this for us, while other (e.g. tokyonight) will
      vim.o.termguicolors = true
      require("bluloco").setup(opts)
      vim.cmd.colorscheme('bluloco')
    end
  },
}
