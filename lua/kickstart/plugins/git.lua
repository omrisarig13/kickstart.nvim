local function _add_file_as_line(file_name)
  local lazy = require 'diffview.lazy'
  local lib = lazy.require 'diffview.lib' ---@module "diffview.lib"
  local view = lib.get_current_view() ---@class DiffView

  if view == nil then
    return
  end

  if view.panel:is_open() then
    local current_item = view.panel:get_item_at_cursor()
    if current_item == nil then
      return
    end
    local is_dir = (current_item.collapsed ~= nil)
    vim.cmd('split ' .. file_name)
    vim.cmd 'wincmd K'
    local last_line = vim.api.nvim_buf_line_count(0)

    local line = current_item.path
    if is_dir then
      line = line .. '/'
    end

    vim.api.nvim_buf_set_lines(0, last_line, last_line, false, { line })
    vim.api.nvim_win_set_cursor(0, { last_line + 1, 0 })
  end
end

local function add_to_exclude()
  _add_file_as_line '.git/info/exclude'
end

local function add_to_ignore()
  _add_file_as_line '.gitignore'
end

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
        -- Diff functions {{{
        local last_diff = ''

        map('n', '<leader>hdd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hdl', function()
          gitsigns.diffthis 'HEAD~'
        end, { desc = 'git [D]iff against [L]ast commit' })
        map('n', '<leader>hds', function()
          print('Diff against ' .. last_diff)
          gitsigns.diffthis(last_diff)
        end, { desc = 'git [D]iff against [S]aved diff' })
        map('n', '<leader>hdi', function()
          vim.ui.input({ prompt = 'Enter reference for diff:' }, function(input)
            last_diff = input
            gitsigns.diffthis(last_diff)
          end)
        end, { desc = 'git [D]iff against [I]nteractive' })
        -- Diff functions }}}
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
      {
        'sindrets/diffview.nvim',
        opts = {
          keymaps = {
            file_panel = {
              {
                'n',
                'cc',
                '<Cmd>Git commit <bar> wincmd K<CR>',
                { desc = 'Commit staged changes' },
              },
              {
                'n',
                'ca',
                '<Cmd>Git commit --amend <bar> wincmd K<CR>',
                { desc = 'Amend the last commit' },
              },
              {
                'n',
                'ce',
                '<Cmd>Git commit --amend --no-edit<CR>',
                { desc = 'Amend the last commit without editting' },
              },
              {
                'n',
                'gi',
                add_to_ignore,
                { desc = 'Add the current file to the .gitignore' },
              },
              {
                'n',
                'gI',
                add_to_exclude,
                { desc = 'Add the current file to the .git/info/exclude' },
              },
            },
          },
        },
      },
    },
    config = function()
      -- Flog will create a new tab if the current one is used, but will not
      -- create one if the current tab is an empty buffer. This means that
      -- running the <leader>gp command when nvim was just opened will fail, as
      -- there is no tab before the current one. Always start this command by
      -- creating the new tab, which will be used for the Flog command.

      vim.keymap.set('n', '<leader>gc', '<cmd>G commit<cr>', { desc = 'Git [C]ommit' })
      vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Git [D]if view open' })
      vim.keymap.set('n', '<leader>gf', '<cmd>G commit --fixup=<c-r>"<cr>', { desc = 'Git [F]ixup (to unnamed register)' })
      vim.keymap.set('n', '<leader>gp', '<cmd>tabnew <bar> exec "Flog" <bar> tabmove-1 <bar> DiffviewOpen <cr>', { desc = 'Git [P]age', silent = true })
      vim.keymap.set('n', '<leader>gl', '<cmd>-tabnew <bar> Flog<cr>', { desc = 'Git f[L]og' })
      vim.keymap.set('n', '<leader>gq', '<cmd>G commit --squash=<c-r>"<cr>', { desc = 'Git s[Q]uash (to unnamed register)' })
      vim.keymap.set('n', '<leader>gs', '<cmd>G show<cr><c-w>T', { desc = 'Git [S]how' })
      vim.keymap.set('n', '<leader>gu', '<cmd>G show <c-r><c-w><cr><c-w>T', { desc = 'Git show commit [U]nder cursor' })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
