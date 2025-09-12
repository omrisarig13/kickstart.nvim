-- Plugins that were ported from my vim configuration. These should be analyzed
-- again and re-evaluated.
return {
  --[[
  {
    'omrisarig13/auto-abbrev.nvim',
    config = function()
      local plugin = require 'auto-abbrev'
      plugin.setup()

      vim.keymap.set('n', '<leader>aa', plugin.interactive_add_abbrev, { desc = '[A]uto-abbrev [A]dd interactive' })
      vim.keymap.set('n', '<leader>al', plugin.save_as_lhs, { desc = '[A]uto-abbrev add [L]eft-hand-size' })
      vim.keymap.set('n', '<leader>ar', plugin.use_as_rhs, { desc = '[A]uto-abbrev add [R]ight-hand-size' })
    end,
  },
  --]]
  -- 'tpope/vim-surround',
  -- 'omrisarig13/vim-auto-abbrev',
  { 'unblevable/quick-scope',        event = 'VeryLazy' },
  { 'tpope/vim-abolish',             event = 'VeryLazy' },
  -- 'wellle/targets.vim',
  -- 'michaeljsmith/vim-indent-object',
  -- 'justinmk/vim-ipmotion',
  { 'omrisarig13/vim-tab-movements', event = 'VeryLazy' },
  -- 'airblade/vim-rooter',
  -- 'junegunn/gv.vim',
  -- 'airblade/vim-gitgutter',
  -- 'tpope/vim-rhubarb',
  -- 'whiteinge/diffconflicts',
  -- 'rhysd/committia.vim',
  -- 'sodapopcan/vim-twiggy',
  -- OMSA: Telescope-undo is also doing the same, and seems to be quite good,
  -- deceide whether mundo is also wanted.
  -- 'simnalamburt/vim-mundo',
  -- 'dominikduda/vim_current_word',
  -- 'tpope/vim-repeat',
  'jeffkreeftmeijer/vim-numbertoggle',
  -- OMSA: This causes nvim to be extremely slow when switching between tabs -
  -- maybe investigate...
  -- { 'zhimsel/vim-stay', event = 'VeryLazy' },
  -- 'markonm/traces.vim',
  { 'tpope/vim-eunuch', event = 'VeryLazy' },
  -- 'kana/vim-operator-user',
  -- 'mwgkgk/vim-operator-insert',
  -- 'mwgkgk/vim-operator-append',
  -- 'svermeulen/vim-subversive',
  -- 'AndrewRadev/splitjoin.vim',
  -- 'rhysd/reply.vim',
  -- 'kana/vim-textobj-user',
  -- 'glts/vim-textobj-comment',
  -- 'sgur/vim-textobj-parameter',
  -- 'rickhowe/wrapwidth',
  {
    -- OMSA: Figure out what mappings are actually available, and whether
    -- any more features are nice other than having the marks visible.
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    config = function()
      require('marks').setup {
        -- whether to map keybinds or not. default true
        default_mappings = false,
        mappings = {},
      }
    end,
  },
  --[[
  {
    'inkarkat/vim-ReplaceWithRegister',
    config = function()
      vim.keymap.set('n', '<leader>r', '<Plug>ReplaceWithRegisterOperator', { desc = 'Replace with register' })
      vim.keymap.set('n', '<leader>rr', '<Plug>ReplaceWithRegisterLine', { desc = 'Replace with register line' })
      vim.keymap.set('v', '<leader>r', '<Plug>ReplaceWithRegisterVisual', { desc = 'Replace with visual' })
    end,
  },
  --]]
  {
    'omrisarig13/mistake.nvim',
    event = 'VeryLazy',
    config = function()
      local plugin = require 'mistake'
      vim.defer_fn(function()
        plugin.setup()
      end, 500)

      vim.keymap.set('n', '<leader>ma', plugin.add_entry, { desc = '[M]istake [A]dd entry' })
      vim.keymap.set('n', '<leader>me', plugin.edit_entries, { desc = '[M]istake [E]dit entries' })
      vim.keymap.set('n', '<leader>mc', plugin.add_entry_under_cursor, { desc = '[M]istake add [C]urrent word' })
    end,
  },
  {
    "dmxk062/hexed.nvim",
    -- default options
    cmd = { 'Hexed' },
    opts = {
      highlights = {
        String  = "String",          -- ascii characters
        Null    = "NonText",         -- null bytes
        Newline = "SpecialChar",     -- newline characters(\n and \r)
        Address = "Label",           -- the addresses at the beginning of lines
        Byte    = "Identifier",      -- any other byte
        Region  = "Visual",          -- context are in preview buffer
        Char    = "Substitute",      -- character the cursor is on
      },
      command = "Hexed",             -- the command used to invoke hexed
    }
  },
  {
    '2kabhishek/tdo.nvim',
    dependencies = '2kabhishek/pickme.nvim',
    cmd = { 'Tdo' },
    keys = {
      { '<leader>df', '<cmd>Tdo files<cr>', desc = 't[D]o [F]iles' },
      { '<leader>dt', '<cmd>Tdo todos<cr>', desc = 't[D]o [T]odos' },
      { '<leader>dd', '<cmd>Tdo<cr>',       desc = 't[D]o' },
    },
    config = function()
      require('tdo').setup {
        use_new_command = true,
        add_default_keybindings = false,
      }
    end
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = { "rcarriga/nvim-dap-ui", "mfussenegger/nvim-dap-python", "nvim-neotest/nvim-nio" },
    cmd = { 'DapContinue', 'DapToggleBreakpoint', 'DapNew' },
    keys = {
      { '<leader>db', '<cmd>DapToggleBreakpoint<cr>', desc = '[D]ap toggle [B]reakpoint' },
      { '<leader>dn', '<cmd>DapNew<cr>',              desc = '[D]ap [N]ew session' },
      { '<leader>ds', '<cmd>DapTerminate<cr>',        desc = '[D]ap [S]top' },
    },
    config = function()
      local dap = require('dap')
      dap.set_log_level('TRACE')

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
      }

      dap.configurations.c = {
        -- {
        --   name = "Launch",
        --   type = "gdb",
        --   request = "launch",
        --   program = function()
        --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        --   end,
        --   cwd = "${workspaceFolder}",
        --   stopAtBeginningOfMainSubprogram = true,
        -- },
        -- {
        --   name = "Select and attach to process",
        --   type = "gdb",
        --   request = "attach",
        --   program = function()
        --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        --   end,
        --   pid = function()
        --     local name = vim.fn.input('Executable name (filter): ')
        --     return require("dap.utils").pick_process({ filter = name })
        --   end,
        --   cwd = '${workspaceFolder}'
        -- },
        {
          name = 'Attach to gdbserver :2331',
          type = 'gdb',
          request = 'attach',
          target = 'localhost:2331',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = true,
        },
        {
          name = 'Quantum: Hello Zephyr',
          type = 'gdb',
          request = 'attach',
          target = 'localhost:2331',
          program =
          '/scratch/omsi/quantum/repo/obj/higgs/higgs_mcu/apps/hello_zephyr/hello_zephyr_package/package/zephyr_build/hello_zephyr/zephyr/zephyr.elf',
          cwd = '${workspaceFolder}',
          stopOnEntry = true,
        },
      }

      -- Dap Python setup
      require('dap-python').setup('/home/omsi/.venv/bin/python')

      -- Dap UI Setup
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Keymaps during debugging
      dap.listeners.before.event_initialized.create_mapping = function()
        vim.keymap.set('n', '<Enter>', dap.continue, { desc = 'Continue' })
        vim.keymap.set('n', '<Down>', dap.step_over, { desc = 'Step over' })
        vim.keymap.set('n', '<Up>', dap.restart_frame, { desc = 'Restart Frame' })
        vim.keymap.set('n', '<Right>', dap.step_into, { desc = 'Step into' })
        vim.keymap.set('n', '<Left>', dap.step_out, { desc = 'Step out' })
        vim.keymap.set({ 'v', 'n' }, '<M-s>', dapui.eval, { desc = 'Evaluate expression under cursor' })
      end
      dap.listeners.before.event_terminated.create_mapping = function()
        vim.keymap.del('n', '<Enter>')
        vim.keymap.del('n', '<Down>')
        vim.keymap.del('n', '<Up>')
        vim.keymap.del('n', '<Right>')
        vim.keymap.del('n', '<Left>')
        vim.keymap.del({ 'v', 'n' }, '<M-s>')
      end
    end
  },
  {
    'stevearc/oil.nvim',

    config = function()
      require('oil').setup {
        default_file_explorer = true,
        columns = { "icon", "permissions", "size", "mtime", },
        constrain_cursor = "name",
      }
    end,

  },

  -- Future plugins... {{{
  -- In case I want to work with GitHub's PR:
  --   pwntester/octo.nvim
  -- More Git plugins
  --   NeogitOrg/neogit
  -- For markdown, not currently working, so debugging is needed.
  --   iamcco/markdown-preview.nvim
  -- Some more:
  --   kevinhwang91/nvim-ufo
  --   SmiteshP/nvim-navic
  --   SmiteshP/nvim-navbuddy
  -- Future plugins... }}}
}

-- vim: foldmethod=marker
