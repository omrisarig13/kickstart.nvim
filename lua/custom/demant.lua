
-- Recognize SCons files as Python
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { 'SConstruct', 'SConscript', '*.scons' },
  callback = function()
    vim.bo.filetype = 'python'
  end,
})
