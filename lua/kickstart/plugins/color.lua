-- Colorschemes installation and configuration
return {
  {
    'catppuccin/nvim',
    priority = 1000,
    name = 'catppuccin',
    config = function()
      -- Load the colorscheme here.
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  { "folke/tokyonight.nvim" },
  { "maxmx03/solarized.nvim" },
  { "rebelot/kanagawa.nvim" },
  {
    "folke/styler.nvim",
    config = function()
      require("styler").setup({
        themes = {
          c = { colorscheme = "catppuccin" },
          python = { colorscheme = "solarized" },
          java = { colorscheme = "kanagawa" },
          rst = { colorscheme = "tokyonight-storm" },
          text = { colorscheme = "tokyonight-storm" },
          markdown = { colorscheme = "tokyonight-storm" },
        },
      })
    end,
  }
}
