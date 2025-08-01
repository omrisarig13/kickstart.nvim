-- Plugins that were ported from my vim configuration. These should be analyzed
-- again and re-evaluated.
return {
  --[[
  {
    'omrisarig13/auto-abbrev.nvim',
    config = function()
      local plugin = require 'auto-abbrev'
      plugin.setup()

      vim.keymap.set('n', '<leader>aa', plugin.interactive_add_abbrev, { desc = '[A]uto-abbrev [A]dd interactive' })
      vim.keymap.set('n', '<leader>al', plugin.save_as_lhs, { desc = '[A]uto-abbrev add [L]eft-hand-size' })
      vim.keymap.set('n', '<leader>ar', plugin.use_as_rhs, { desc = '[A]uto-abbrev add [R]ight-hand-size' })
    end,
  },
  --]]
  -- 'tpope/vim-surround',
  -- 'omrisarig13/vim-auto-abbrev',
  { 'unblevable/quick-scope', event = 'VeryLazy' },
  { 'tpope/vim-abolish', event = 'VeryLazy' },
  -- 'wellle/targets.vim',
  -- 'michaeljsmith/vim-indent-object',
  -- 'justinmk/vim-ipmotion',
  { 'omrisarig13/vim-tab-movements', event = 'VeryLazy' },
  -- 'airblade/vim-rooter',
  -- 'junegunn/gv.vim',
  -- 'airblade/vim-gitgutter',
  -- 'tpope/vim-rhubarb',
  -- 'whiteinge/diffconflicts',
  -- 'rhysd/committia.vim',
  -- 'sodapopcan/vim-twiggy',
  -- OMSA: Telescope-undo is also doing the same, and seems to be quite good,
  -- deceide whether mundo is also wanted.
  -- 'simnalamburt/vim-mundo',
  -- 'dominikduda/vim_current_word',
  -- 'tpope/vim-repeat',
  'jeffkreeftmeijer/vim-numbertoggle',
  -- OMSA: This causes nvim to be extremely slow when switching between tabs -
  -- maybe investigate...
  -- { 'zhimsel/vim-stay', event = 'VeryLazy' },
  -- 'markonm/traces.vim',
  { 'tpope/vim-eunuch', event = 'VeryLazy' },
  -- 'kana/vim-operator-user',
  -- 'mwgkgk/vim-operator-insert',
  -- 'mwgkgk/vim-operator-append',
  -- 'svermeulen/vim-subversive',
  -- 'AndrewRadev/splitjoin.vim',
  -- 'rhysd/reply.vim',
  -- 'kana/vim-textobj-user',
  -- 'glts/vim-textobj-comment',
  -- 'sgur/vim-textobj-parameter',
  -- 'rickhowe/wrapwidth',
  {
    -- OMSA: Figure out what mappings are actually available, and whether
    -- any more features are nice other than having the marks visible.
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    config = function()
      require('marks').setup {
        -- whether to map keybinds or not. default true
        default_mappings = false,
        mappings = {},
      }
    end,
  },
  --[[
  {
    'inkarkat/vim-ReplaceWithRegister',
    config = function()
      vim.keymap.set('n', '<leader>r', '<Plug>ReplaceWithRegisterOperator', { desc = 'Replace with register' })
      vim.keymap.set('n', '<leader>rr', '<Plug>ReplaceWithRegisterLine', { desc = 'Replace with register line' })
      vim.keymap.set('v', '<leader>r', '<Plug>ReplaceWithRegisterVisual', { desc = 'Replace with visual' })
    end,
  },
  --]]
  {
    'omrisarig13/mistake.nvim',
    event = 'VeryLazy',
    config = function()
      local plugin = require 'mistake'
      vim.defer_fn(function()
        plugin.setup()
      end, 500)

      vim.keymap.set('n', '<leader>ma', plugin.add_entry, { desc = '[M]istake [A]dd entry' })
      vim.keymap.set('n', '<leader>me', plugin.edit_entries, { desc = '[M]istake [E]dit entries' })
      vim.keymap.set('n', '<leader>mc', plugin.add_entry_under_cursor, { desc = '[M]istake add [C]urrent word' })
    end,
  },
  {
    "dmxk062/hexed.nvim",
    -- default options
    cmd = { 'Hexed' },
    opts = {
        highlights = {
            String  = "String",         -- ascii characters
            Null    = "NonText",        -- null bytes
            Newline = "SpecialChar",    -- newline characters(\n and \r)
            Address = "Label",          -- the addresses at the beginning of lines
            Byte    = "Identifier",     -- any other byte
            Region  = "Visual",         -- context are in preview buffer
            Char    = "Substitute",     -- character the cursor is on
        },
        command = "Hexed",              -- the command used to invoke hexed
    }
  },
  {
    '2kabhishek/tdo.nvim',
    dependencies =  '2kabhishek/pickme.nvim',
    cmd = { 'Tdo' },
    keys = {
      { '<leader>df', '<cmd>Tdo files<cr>', desc = 't[D]o [F]iles' },
      { '<leader>dt', '<cmd>Tdo todos<cr>', desc = 't[D]o [T]odos' },
      { '<leader>dd', '<cmd>Tdo<cr>', desc = 't[D]o' },
    },
    config = function()
      require('tdo').setup {
        use_new_command = true,
        add_default_keybindings = false,
      }
    end
  },

  -- Future plugins... {{{
  -- In case I want to work with GitHub's PR:
  --   pwntester/octo.nvim
  -- More Git plugins
  --   NeogitOrg/neogit
  -- For markdown, not currently working, so debugging is needed.
  --   iamcco/markdown-preview.nvim
  -- Some more:
  --   kevinhwang91/nvim-ufo
  --   SmiteshP/nvim-navic
  --   SmiteshP/nvim-navbuddy
  -- Future plugins... }}}
}
--
-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
