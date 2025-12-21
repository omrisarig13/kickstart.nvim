-- General Neovim settings

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Disable mause, just annoying.
vim.o.mouse = ''

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = false

--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
-- Show tabs, trailing spaces and multiple-spaces as characters, to be able to
-- quickly distinguish them. The laeding spaces are converted to regular spaces,
-- as they should not be shown differently (0x20 = space, as space cannot be set
-- directly there).
vim.opt.listchars = {
  tab = '<->',
  trail = '-',
  multispace = '.',
  lead = '\\x20',
}

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
-- OMSA: Look at this value again, decide if this is too much.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Break the lines at end of window, not spliting words.
vim.o.wrap = true
vim.o.linebreak = true

-- Set textwidth {{{
-- Default to 79, override by filetype
vim.o.textwidth = 79
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'python' },
  callback = function()
    vim.opt_local.textwidth = 120
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rst' },
  callback = function()
    vim.opt_local.textwidth = 119
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'java' },
  callback = function()
    vim.opt_local.textwidth = 149
  end,
})

-- Add a colored column at the end of wanted lines.
vim.o.colorcolumn = '+1'
-- Set textwidth }}}

-- Update foldmethod to git files, so git commits are shown nicer
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'git',
  callback = function()
    vim.opt_local.foldmethod = 'syntax'
  end,
})

-- tab options {{{
-- Default to 4 spaces
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.shiftround = true

-- Change to 2 spaces for certain filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'rst', 'xml', 'lua' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
-- tab options }}}

-- vim: foldmethod=marker
