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
  'unblevable/quick-scope',
  'tpope/vim-abolish',
  -- 'wellle/targets.vim',
  -- 'michaeljsmith/vim-indent-object',
  -- 'justinmk/vim-ipmotion',
  'omrisarig13/vim-tab-movements',
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
  'zhimsel/vim-stay',
  -- 'markonm/traces.vim',
  'tpope/vim-eunuch',
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
    branch = 'omsa/add-current-word',
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

  -- Just for fun, not really needed.
  'vuciv/golf',
}
