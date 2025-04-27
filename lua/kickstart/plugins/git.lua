return {
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation {{{
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })
        -- Navigation }}}

        -- Actions {{{
        -- visual mode {{{
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        -- visual mode }}}
        -- normal mode {{{
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame, { desc = 'git [b]lame' })
        map('n', '<leader>gb', gitsigns.blame, { desc = 'git [b]lame' })
        map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'git [i]nline hunk preview' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- normal mode }}}
        -- Populate quickfix with hunks. {{{
        map('n', '<leader>hq', gitsigns.setqflist, { desc = 'pupulate [q]uickfix with file hunks' })
        map('n', '<leader>hQ', function()
          gitsigns.setqflist 'all'
        end, { desc = 'pupulate [q]uickfix with all file hunks' })
        -- Populate quickfix with hunks. }}}
        -- Actions }}}
        -- Toggles {{{
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle git blame on line' })
        map('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'Toggle shown deleted git content' })
        map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'Toggle a git highlight for all changed words' })
        -- Toggles }}}
        -- Text object {{{
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Select the current git hunk' })
        -- Text object }}}
      end,
    },
  },
  {
    -- Add fugitive, flog, and common keymaps.
    'tpope/vim-fugitive',
    dependencies = {
      'rbong/vim-flog',
    },
    config = function()
      -- OMSA: The first 2 are probably not going to be used, maybe
      -- remove them?
      vim.keymap.set('n', '<leader>gl', ':Flog<cr>', { desc = 'Git full-short-[L]og' })
      vim.keymap.set('n', '<leader>gL', ':exec "Flog" | tabmove-1<cr>', { desc = 'Git full-short-[L]og', silent = true })
      -- OMSA: This requires fugitive, not sure how to handle this yet.
      --
      -- Flog will create a new tab if the current one is used, but will not
      -- create one if the current tab is an empty buffer. This means that
      -- running this command when vim was just opened will fail, as there is
      -- no tab before the current one. Always start the command by creating
      -- the new tab, which will be used for the Flog command.
      vim.keymap.set('n', '<leader>gp', ':tabnew | exec "Flog" | tabmove-1 | G<cr>', { desc = 'Git [P]age', silent = true })
      vim.keymap.set('n', '<leader>gs', ':G show<cr><c-w>T', { desc = 'Git [S]how' })
      vim.keymap.set('n', '<leader>gu', ':G show <c-r><c-w><cr><c-w>T', { desc = 'Git show commit [U]nder cursor' })
      vim.keymap.set('n', '<leader>gf', ':G commit --fixup=<c-r>"<cr>', { desc = 'Git [F]ixup (to unnamed register)' })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
