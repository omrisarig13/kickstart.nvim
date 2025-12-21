--[[

This file provides temporary settings for the neovim configuration, that should
still be investigated and updated when time allows.

--]]

-- Spell checking {{{
-- TODO: Update the spellfile location, and make it generated automatically in a
-- proper place.
vim.o.spell = true
vim.o.spelllang = 'en_us'
vim.o.spellfile = '/home/omsi/.config/nvim-kickstart/omsa-spell.utf-8.add'
-- Spell checking. }}}

vim.keymap.set('n', '<C-Right>', [[<cmd>vertical resize +5<cr>]])  -- make the window biger vertically
vim.keymap.set('n', '<C-Left>', [[<cmd>vertical resize -5<cr>]])   -- make the window smaller vertically
vim.keymap.set('n', '<C-Up>', [[<cmd>horizontal resize +2<cr>]])   -- make the window bigger horizontally by pressing shift and =
vim.keymap.set('n', '<C-Down>', [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -

-- vim: foldmethod=marker
