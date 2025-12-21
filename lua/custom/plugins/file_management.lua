return {
  { 'tpope/vim-eunuch', event = 'VeryLazy' },
  {
    "dmxk062/hexed.nvim",
    -- default options
    cmd = { 'Hexed' },
    opts = {
      highlights = {
        String  = "String",      -- ascii characters
        Null    = "NonText",     -- null bytes
        Newline = "SpecialChar", -- newline characters(\n and \r)
        Address = "Label",       -- the addresses at the beginning of lines
        Byte    = "Identifier",  -- any other byte
        Region  = "Visual",      -- context are in preview buffer
        Char    = "Substitute",  -- character the cursor is on
      },
      command = "Hexed",         -- the command used to invoke hexed
    }
  },
  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup {
        default_file_explorer = true,
        columns = { "icon", "permissions", "size", "mtime", },
        constrain_cursor = "name",
      }
    end,
  },
  {
    '2kabhishek/tdo.nvim',
    dependencies = '2kabhishek/pickme.nvim',
    cmd = { 'Tdo' },
    keys = {
      { '<leader>df', '<cmd>Tdo files<cr>', desc = 't[D]o [F]iles' },
      { '<leader>dt', '<cmd>Tdo todos<cr>', desc = 't[D]o [T]odos' },
      { '<leader>dd', '<cmd>Tdo<cr>',       desc = 't[D]o' },
    },
    config = function()
      require('tdo').setup {
        use_new_command = true,
        add_default_keybindings = false,
      }
    end
  },

}
