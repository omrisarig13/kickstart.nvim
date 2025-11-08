return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    -- treesitter options are not working as expected.
    keys = {
      -- Default 's' conflicts with surround.
      {
        '<leader>n',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
    },
  },
}
