
-- Recognize SCons files as Python
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { 'SConstruct', 'SConscript', '*.scons' },
  callback = function()
    vim.bo.filetype = 'python'
  end,
})

local quantum_base_path = '/scratch/omsi/quantum/'

-- Open a 3-way merge view for the file path stored in the clipboard
local function open_merge()
  -- Get clipboard content
  local clipboard = vim.fn.getreg('+')
  if clipboard == '' then
    vim.notify('Clipboard is empty', vim.log.levels.WARN)
    return
  end

  -- Open new tab
  vim.cmd('tabnew')

  -- Open master version
  local master_file = quantum_base_path .. '/master/' .. clipboard
  vim.cmd('edit ' .. vim.fn.fnameescape(master_file))

  -- Open current version in vsplit
  vim.cmd('vsplit ' .. vim.fn.fnameescape(clipboard))

  -- Open gen-9 version in vsplit
  local gen9_file = quantum_base_path .. '/gen-9/' .. clipboard
  vim.cmd('vsplit ' .. vim.fn.fnameescape(gen9_file))

  -- Enable diff mode for all windows
  vim.cmd('windo diffthis')
end

local function diff_branches()
  local current_line = vim.fn.line('.')
  print('Setting cursor to line ' .. current_line)

  local file_to_open = get_filename_relative_to_git_root()

  local master_file = quantum_base_path .. '/master/' .. file_to_open
  vim.cmd('tabnew ' .. vim.fn.fnameescape(master_file))
  vim.fn.cursor(current_line, 1)

  local gen9_file = quantum_base_path .. '/gen-9/' .. file_to_open
  vim.cmd('vsplit ' .. vim.fn.fnameescape(gen9_file))

  vim.cmd('windo diffthis')
  vim.cmd('windo %foldopen')
  vim.fn.cursor(current_line, 1)
  vim.cmd('normal <c-w>d') -- Move to the other window
  vim.fn.cursor(current_line, 1)
end

vim.keymap.set('n', '<leader>am', open_merge, { desc = 'Dem[A]nt Quantum open m[E]rge' })
vim.keymap.set('n', '<leader>ad', diff_branches, { desc = 'Dem[A]nt Quantum [D]if master and gen-9.0 of current file' })
