return {
  {
    'github/copilot.vim',
    event = 'VeryLazy',
    config = function()
      vim.keymap.set('i', '<C-space>', '<Plug>(copilot-suggest)')
      vim.keymap.set('i', '<C-b>', '<Plug>(copilot-next)')

      -- Create a keymap to toggle copilot enable<->disable
      -- Copilot does not support checking if it is globally enabled or
      -- disabled, so create a variable here, and manually change it when
      -- toggling with the keymap.
      -- This will break if the user changes the copilot settings manually (by
      -- running "Copilot enable/disable"). In this case, the next toggle
      -- keymap will not change the copilot settings. That's okay here, as I'll
      -- always be using the keymap to toggle it.
      vim.g.copilot_enabled = true
      vim.keymap.set('n', '<leader>tc', function()
        if vim.g.copilot_enabled then
          vim.cmd 'Copilot disable'
          vim.g.copilot_enabled = false
          print 'Copilot Disabled'
        else
          vim.cmd 'Copilot enable'
          vim.g.copilot_enabled = true
          print 'Copilot Enabled'
        end
      end, { desc = '[C]opilot [T]oggle' })

      vim.keymap.set('n', '<leader>uc', ':Copilot status<CR>', { desc = 'Stat[U]s [C]opilot' })

      -- Accept Copilot suggestion with Ctrl-Space only in Copilot Chat window
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'copilot-chat',
        callback = function()
          vim.keymap.set('i', '<C-E>', 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false,
          })
        end,
      })

      vim.g.copilot_filetypes = { gitcommit = true }
    end,
  },
  -- {
  --   'CopilotC-Nvim/CopilotChat.nvim',
  --   dependencies = {
  --     { 'github/copilot.vim' },                       -- or zbirenbaum/copilot.lua
  --     { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
  --   },
  --   build = 'make tiktoken',                          -- Only on MacOS or Linux
  --   keys = {
  --     { '<leader>cc', '<cmd>CopilotChatOpen<cr>',     mode = { 'n', 'v' }, desc = '[C]opilot [C]hat open' },
  --     { '<leader>ce', '<cmd>CopilotChatExplain<cr>',  mode = { 'n', 'v' }, desc = '[C]opilot chat [E]xplain' },
  --     { '<leader>cf', '<cmd>CopilotChatFix<cr>',      mode = { 'n', 'v' }, desc = '[C]opilot chat [F]ix' },
  --     { '<leader>cm', '<cmd>CopilotChatCommit<cr>',   mode = { 'n', 'v' }, desc = '[C]opilot chat co[M]mit' },
  --     { '<leader>co', '<cmd>CopilotChatOptimize<cr>', mode = { 'n', 'v' }, desc = '[C]opilot chat [O]ptimize' },
  --     { '<leader>cp', '<cmd>CopilotChatPrompts<cr>',  mode = { 'n', 'v' }, desc = '[C]opilot chat [P]rompts' },
  --     { '<leader>cr', '<cmd>CopilotChatReview<cr>',   mode = { 'n', 'v' }, desc = '[C]opilot chat [R]eview' },
  --   },
  --   config = function()
  --     local local_prompts = require('CopilotChat.config.prompts')
  --     local_prompts['Commit'] = {
  --       prompt =
  --       'Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.',
  --       sticky = '#buffer',
  --     }
  --     require('CopilotChat').setup {
  --       model = 'claude-sonnet-4',
  --       prompts = local_prompts
  --     }
  --
  --     vim.api.nvim_create_autocmd('BufReadPost', {
  --       pattern = '*',
  --       callback = function()
  --         if vim.bo.filetype == 'markdown' and (vim.fn.search('^@@', 'nw') > 0 or vim.fn.search('^diff --git', 'nw') > 0) then
  --           vim.bo.filetype = 'diff'
  --           vim.wo.conceallevel = 0
  --         end
  --       end,
  --     })
  --   end,
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },
  -- {
  --   -- TODO: Look further into it, to understand if it can be utilized better.
  --   -- It creates more of an agentic model, but I'm not sure how happy I'm with
  --   -- that in a normal workflow.
  --   "olimorris/codecompanion.nvim",
  --   cmd = { 'CodeCompanion', 'CodeCompanionChat' },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   opts = {
  --     strategies = {
  --       chat = {
  --         adapter = "copilot",
  --       },
  --     },
  --     inline = {
  --       adapter = "copilot",
  --     },
  --     opts = {
  --       log_level = "DEBUG",
  --     },
  --   },
  -- },
  {
    "KostkaBrukowa/copilot-cli.nvim",
    cmd = "Copilot",
    -- Example key mappings for common actions:
    keys = {
      { "<leader>a/", "<cmd>Copilot toggle<cr>",   desc = "Toggle Copilot CLI" },
      { "<leader>aa", "<cmd>Copilot ask<cr>",      desc = "Ask Copilot",       mode = { "n", "v" } },
      { "<leader>af", "<cmd>Copilot add_file<cr>", desc = "Add File" },
    },
    dependencies = {
      "folke/snacks.nvim",
    },
    config = true,
  }
}
-- vim: foldmethod=marker
