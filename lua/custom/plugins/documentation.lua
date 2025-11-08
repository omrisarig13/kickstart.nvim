return {
  -- todo-comments {{{
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('todo-comments').setup {
        signs = false,
        keywords = {
          OMSA = { icon = ' ', color = 'info' },
          OMSI = { icon = ' ', color = 'info' },
        },
      }
      vim.keymap.set('n', ']f', function()
        require('todo-comments').jump_next { keywords = { 'TODO', 'OMSA', 'FIXME' } }
      end, { desc = 'Next [F]ixme comment (TODO, FIXME, OMSA)' })
      vim.keymap.set('n', '[f', function()
        require('todo-comments').jump_prev { keywords = { 'TODO', 'OMSA', 'FIXME' } }
      end, { desc = 'Previous [F]ixme comment (TODO, FIXME, OMSA)' })
    end,
  },
  -- todo-comments }}}
}
-- vim: foldmethod=marker
