return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    -- event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    event = 'VeryLazy', -- OMSA: This is the recommended from the help, look over it again.
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen.
      -- Have a short delay to avoid the window opening when I know what I want
      -- to type.
      delay = 200,
      preset = 'modern',
      plugins = {
        spelling = {
          -- OMSA: This is not working properly, see: https://github.com/folke/which-key.nvim/issues/971
          enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        },
      },
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {

        { '<leader>g', group = '[G]it commands' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>hd', group = 'Git [H]unk [D]if' },
        { '<leader>i', group = 'M[I]ni' },
        { '<leader>if', group = 'M[I]ni [F]ile explorer' },
        { '<leader>is', group = 'M[I]ni [S]ession' },
        { '<leader>m', group = '[M]istake' },
        { '<leader>n', group = 'Flash' }, -- Not a group, but saved to keep track.
        { '<leader>o', group = 'Snacks' },
        { '<leader>p', group = '[P]ersonal' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>sg', group = '[S]earch [G]it' },
        { '<leader>t', group = '[T]oggle/[T]ab' },
        { '<leader>u', group = 'Stat[U]s' },
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
