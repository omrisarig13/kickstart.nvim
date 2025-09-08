--[[

This file provides temporary settings for the neovim configuration, that should
still be investigated and updated when time allows.

--]]

-- TODO: Change by file-type. {{{
-- Set textwidth to end at 80.
vim.o.textwidth = 79
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp' },
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
-- TODO: Change by file-type. }}}

-- TODO: Temporary mapping, while still working on re-learning. {{{
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('Q', 'windo q', {})

local function format_table() -- {{{
  -- Save current cursor position
  local original_pos = vim.api.nvim_win_get_cursor(0)

  -- Find table boundaries using Lua APIs
  local current_line = vim.fn.line('.')
  local buffer_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Find start of table (first non-empty line going up)
  local table_start = current_line
  while table_start > 1 and buffer_lines[table_start - 1]:match('%S') do
    table_start = table_start - 1
  end

  -- Find end of table (last non-empty line going down)
  local table_end = current_line
  while table_end < #buffer_lines and buffer_lines[table_end]:match('%S') do
    table_end = table_end + 1
  end
  table_end = table_end - 1

  if table_start >= table_end then
    print("No table found or table is too small")
    return
  end

  -- Get table content and remove headers in one pass
  local table_lines = {}
  for i = table_start, table_end do
    local line = buffer_lines[i]
    -- Skip header separator lines (lines with only -, =, +, |, and spaces)
    if not line:match('^[%s|%-%=%+]*$') then
      -- Normalize spaces around pipes
      line = line:gsub('%s+|%s+', ' | '):gsub('%s+', ' ')
      table.insert(table_lines, line)
    end
  end

  if #table_lines == 0 then
    print("No table content found")
    return
  end

  -- Format table using column command
  local formatted_content = table.concat(table_lines, '\n')
  local handle = io.popen("echo '" .. formatted_content:gsub("'", "'\\''") .. "' | column -t -s '|' -o '|'")
  local formatted_result = handle:read('*a'):gsub('\n$', '') -- Remove trailing newline
  handle:close()

  -- Split result back into lines
  local formatted_lines = vim.split(formatted_result, '\n')

  -- Create separator line pattern based on first line structure
  local separator_line = ""
  if #formatted_lines > 0 then
    separator_line = formatted_lines[1]:gsub('[^|]', '-'):gsub('|', '+')
  end

  -- Build final table with separators
  local final_lines = {}

  -- Add top separator
  if separator_line ~= "" then
    table.insert(final_lines, separator_line)
  end

  for i, line in ipairs(formatted_lines) do
    table.insert(final_lines, line)

    -- Add header separator after first line (header)
    if i == 1 and separator_line ~= "" then
      local header_sep = separator_line:gsub('-', '=')
      table.insert(final_lines, header_sep)
    -- Add regular separator after each subsequent line (except the last)
    elseif i > 1 and i < #formatted_lines and separator_line ~= "" then
      table.insert(final_lines, separator_line)
    end
  end

  -- Add bottom separator
  if separator_line ~= "" then
    table.insert(final_lines, separator_line)
  end

  -- Replace original table content
  vim.api.nvim_buf_set_lines(0, table_start - 1, table_end, false, final_lines)

  -- Restore cursor position (adjust for potential line count changes)
  local line_diff = #final_lines - (table_end - table_start + 1)
  local new_row = math.min(original_pos[1] + line_diff, vim.api.nvim_buf_line_count(0))
  vim.api.nvim_win_set_cursor(0, {new_row, original_pos[2]})
end -- }}}

vim.cmd 'command! Lcdc lcd %:h'

local function copy_file_line_info()
  local filename = vim.fn.expand('%:t')  -- Get just the filename (not full path)
  local line_number = vim.api.nvim_win_get_cursor(0)[1]  -- Get current line number
  local file_line_info = filename .. ':' .. line_number
  vim.fn.setreg('+', file_line_info)
end

local function toggle_tab_width()
  local current_tabstop = vim.bo.tabstop
  local new_tabstop = current_tabstop == 2 and 4 or 2
  vim.bo.tabstop = new_tabstop
  vim.bo.shiftwidth = new_tabstop
  vim.bo.softtabstop = new_tabstop
end

vim.keymap.set('n', '<leader>pc', ':Lcdc<cr>', { desc = '[P]ersonal [C]hange directory' })
vim.keymap.set('n', '<leader>pf', format_table, { desc = '[P]ersonal format [T]able' })
vim.keymap.set('n', '<leader>pt', toggle_tab_width, { desc = '[P]ersonal toggle [T]ab' })
vim.keymap.set('n', '<leader>pw', ":s/ not/n't/e<cr>:s/ is/'s/e<cr>", { desc = '[P]ersonal fix too [W]ordy' })
vim.keymap.set('n', '<leader>py', copy_file_line_info, { desc = '[P]ersonal [Y]ank file:line_number to clipboard' })

local function close_tabs_to_right()
  local current_tab_page = vim.fn.tabpagenr()
  local total_tabs = vim.fn.tabpagenr '$'
  for tabnr = total_tabs, current_tab_page + 1, -1 do
    vim.cmd('tabclose ' .. tabnr)
  end
end
vim.keymap.set('n', '<leader>tr', close_tabs_to_right, { desc = '[T]ab close tabs to the [R]ight' })

local function close_tabs_to_left()
  local current_tab_page = vim.fn.tabpagenr()
  for tabnr = current_tab_page - 1, 1, -1 do
    vim.cmd('tabclose ' .. tabnr)
  end
end
vim.keymap.set('n', '<leader>tl', close_tabs_to_left, { desc = '[T]ab close tabs to the [L]eft' })

-- Remap <c-t> to tab, instead of moving the whole line
vim.keymap.set('i', '<c-t>', '<Tab>')

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'git',
  callback = function()
    vim.opt_local.foldmethod = 'syntax'
  end,
})

-- TODO: Temporary mapping, while still working on re-learning. }}}

-- TODO: Tab options, was not re-investigated yet. {{{
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.shiftround = true

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'rst', 'xml', 'lua' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- TODO: Tab options, was not re-investigated yet. }}}

-- Spell checking {{{
-- TODO: Update the spellfile location, and make it generated automatically in a
-- proper place.
vim.o.spell = true
vim.o.spelllang = 'en_us'
vim.o.spellfile = '/home/omsi/.config/nvim-kickstart/omsa-spell.utf-8.add'

vim.keymap.set('n', '<C-Right>', [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set('n', '<C-Left>', [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
vim.keymap.set('n', '<C-Up>', [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set('n', '<C-Down>', [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -

-- Spell checking. }}}

-- vim: foldmethod=marker
