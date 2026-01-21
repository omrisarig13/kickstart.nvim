-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = '-'

-- Enable nerd-font, as it is used.
vim.g.have_nerd_font = true

require('custom.settings')
require('custom.tmp_settings')
require('custom.personal_commands')
require('custom.demant')
require('custom.basic_keymaps')
require('custom.personal_keymaps')
require('custom.basic_autocommands')

-- [[ Install `lazy.nvim` plugin manager ]] {{{
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)
-- [[ Install `lazy.nvim` plugin manager ]] }}}

-- [[ Configure and install plugins ]] {{{
require('lazy').setup({
  require('kickstart.plugins.color'),
  require('kickstart.plugins.git'),
  require('kickstart.plugins.lint'),
  require('kickstart.plugins.telescope'),
  require('kickstart.plugins.which-key'),
  { import = 'custom.plugins' },
}, {
  ui = { -- {{{
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  }, -- }}}
})
-- [[ Configure and install plugins ]] }}}

-- vim.lsp.config['xuda_ls'] = {
--   cmd = { 'node', '/scratch/omsi/repos/xuda-language-server/server/dist/standalone.js', '--stdio' },
--   filetypes = { 'xuda' },
-- }
-- vim.lsp.enable('xuda_ls')

-- vim: foldmethod=marker
