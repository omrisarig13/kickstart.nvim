
-- Helper functions {{{
-- table formatting {{{
local function format_table()
  -- Save current cursor position
  local original_pos = vim.api.nvim_win_get_cursor(0)

  -- Find table boundaries
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
  vim.api.nvim_win_set_cursor(0, { new_row, original_pos[2] })
end
-- table formatting }}}

-- Filename copy functionality {{{
local function get_filename_relative_to_git_root()
  local Path = require 'plenary.path'
  local cwd = vim.loop.cwd()
  local git_root = Path:new(cwd):find_upwards '.git'
  local file = vim.fn.expand '%:p'
  local path = ''
  if git_root then
    local root = git_root:parent():absolute()
    path = Path:new(file):make_relative(root)
  else
    path = vim.fn.expand('%')
  end
  return path
end

-- Copy <filename> to clipboard
local function copy_filename()
  local filename = vim.fn.expand('%:t')                 -- Get just the filename (not full path)
  vim.fn.setreg('+', filename)
end

 -- Copy <filename:line_number> to clipboard
local function copy_filename_line()
  local filename = vim.fn.expand('%:t')                 -- Get just the filename (not full path)
  local line_number = vim.api.nvim_win_get_cursor(0)[1] -- Get current line number
  local file_line_info = filename .. ':' .. line_number
  vim.fn.setreg('+', file_line_info)
end

-- Copy <full_file_path> to clipboard
local function copy_full_file()
  local filename = vim.fn.expand('%')                   -- Get the full path
  vim.fn.setreg('+', filename)
end

-- Copy <full_file_path:line_number> to clipboard
local function copy_full_file_line()
  local filename = vim.fn.expand('%')                   -- Get the full path
  local line_number = vim.api.nvim_win_get_cursor(0)[1] -- Get current line number
  local file_line_info = filename .. ':' .. line_number
  vim.fn.setreg('+', file_line_info)
end

-- Copy <git_relative_path> to clipboard
local function copy_git_relative_file()
  local filename = get_filename_relative_to_git_root()
  vim.fn.setreg('+', filename)
end

-- Copy <git_relative_path:line_number> to clipboard
local function copy_git_relative_file_line()
  local filename = get_filename_relative_to_git_root()
  local line_number = vim.api.nvim_win_get_cursor(0)[1] -- Get current line number
  local file_line_info = filename .. ':' .. line_number
  vim.fn.setreg('+', file_line_info)
end
-- Filename copy functionality }}}

local function toggle_tab_width()
  local current_tabstop = vim.bo.tabstop
  local new_tabstop = current_tabstop == 2 and 4 or 2
  vim.bo.tabstop = new_tabstop
  vim.bo.shiftwidth = new_tabstop
  vim.bo.softtabstop = new_tabstop
end

local function toggle_markdown_checkbox()
  local current_line = vim.api.nvim_get_current_line()
  local new_line

  if current_line:match('%- %[ %]') then
    -- Change unchecked to checked
    new_line = current_line:gsub('%- %[ %]', '- [x]')
  elseif current_line:match('%- %[x%]') then
    -- Change checked to unchecked
    new_line = current_line:gsub('%- %[x%]', '- [ ]')
  else
    -- No checkbox found, don't change anything
    return
  end

  -- Replace the current line
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { new_line })
end

local function close_tabs_to_right()
  local current_tab_page = vim.fn.tabpagenr()
  local total_tabs = vim.fn.tabpagenr '$'
  for tabnr = total_tabs, current_tab_page + 1, -1 do
    vim.cmd('tabclose ' .. tabnr)
  end
end
local function close_tabs_to_left()
  local current_tab_page = vim.fn.tabpagenr()
  for tabnr = current_tab_page - 1, 1, -1 do
    vim.cmd('tabclose ' .. tabnr)
  end
end

local function toggle_mouse()
  if vim.o.mouse == 'a' then
    vim.o.mouse = ''
    print('Mouse disabled')
  else
    vim.o.mouse = 'a'
    print('Mouse enabled')
  end
end

local function toggle_diff()
  -- Check if nvim is in diff mode - if not, start a diff of all the files in
  -- the tab, otherwise turn off diff mode.
  if not vim.o.diff then
    vim.cmd('windo diffthis')
  else
    vim.cmd('windo diffoff')
  end
end

-- Helper functions }}}

-- Keymaps {{{

vim.keymap.set('n', '<leader>tl', close_tabs_to_left, { desc = '[T]ab close tabs to the [L]eft' })
vim.keymap.set('n', '<leader>tr', close_tabs_to_right, { desc = '[T]ab close tabs to the [R]ight' })

vim.keymap.set('n', '<leader>pc', ':lcd %:h<cr>', { desc = '[P]ersonal [C]hange directory' })
vim.keymap.set('n', '<leader>pd', toggle_diff, { desc = '[P]ersonal [D]iff toggle' })
vim.keymap.set('n', '<leader>pf', format_table, { desc = '[P]ersonal format [T]able' })
vim.keymap.set('n', '<leader>ph', toggle_markdown_checkbox, { desc = '[P]ersonal c[H]eckbox toggle' })
vim.keymap.set('n', '<leader>pm', toggle_mouse, { desc = '[P]ersonal toggle [M]ouse' })
vim.keymap.set('n', '<leader>pob', '<cmd>tabnew ~/.bashrc<CR>', { desc = '[P]ersonal c[O]nfiguration [B]ashrc' })
vim.keymap.set('n', '<leader>pod', '<cmd>tabnew ~/.config/personal/demant<CR>', { desc = '[P]ersonal c[O]nfiguration [D]emant' })
vim.keymap.set('n', '<leader>pt', toggle_tab_width, { desc = '[P]ersonal toggle [T]ab' })
vim.keymap.set('n', '<leader>pw', ":s/ not/n't/e<cr>:s/ is/'s/e<cr>", { desc = '[P]ersonal fix too [W]ordy' })
vim.keymap.set('n', '<leader>pyf', copy_filename, { desc = '[P]ersonal [Y]ank [F]ilename' })
vim.keymap.set('n', '<leader>pyg', copy_git_relative_file, { desc = '[P]ersonal [Y]ank [G]it relative file path' })
vim.keymap.set('n', '<leader>pynf', copy_filename_line, { desc = '[P]ersonal [Y]ank [F]ilename and line[N]umber' })
vim.keymap.set('n', '<leader>pyng', copy_git_relative_file_line, { desc = '[P]ersonal [Y]ank [G]it relative [F]ile path and line[N]umber' })
vim.keymap.set('n', '<leader>pynu', copy_full_file_line, { desc = '[P]ersonal [Y]ank f[U]ll file path and line[N]umber' })
vim.keymap.set('n', '<leader>pyu', copy_full_file, { desc = '[P]ersonal [Y]ank f[U]ll file path' })

-- Keymaps }}}

-- vim: foldmethod=marker
