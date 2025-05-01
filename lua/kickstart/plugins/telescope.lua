return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      'davvid/telescope-git-grep.nvim',
      'debugloop/telescope-undo.nvim',
      'rcarriga/nvim-notify',
      -- TODO: Also look at this one: https://github.com/aaronhallaert/advanced-git-search.nvim
      'aaronhallaert/advanced-git-search.nvim',
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`

      -- This lets us move to the preview window, and do any vim-operations
      -- there.
      local focus_preview = function(prompt_bufnr)
        local action_state = require 'telescope.actions.state'
        local picker = action_state.get_current_picker(prompt_bufnr)
        local prompt_win = picker.prompt_win
        local previewer = picker.previewer
        local bufnr = previewer.state.bufnr or previewer.state.termopen_bufnr
        local winid = previewer.state.winid or vim.fn.win_findbuf(bufnr)[1]
        vim.keymap.set('n', '<Tab>', function()
          vim.cmd 'setlocal nonumber norelativenumber'
          vim.cmd(string.format('noautocmd lua vim.api.nvim_set_current_win(%s)', prompt_win))
        end, { buffer = bufnr })
        vim.cmd(string.format('noautocmd lua vim.api.nvim_set_current_win(%s)', winid))
        vim.cmd 'setlocal nomodifiable number relativenumber'
      end

      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        defaults = {
          mappings = {
            i = { ['<Tab>'] = focus_preview },
            n = { ['<Tab>'] = focus_preview },
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'git_grep')
      pcall(require('telescope').load_extension, 'undo')
      pcall(require('telescope').load_extension, 'notify')
      pcall(require('telescope').load_extension, 'advanced_git_search')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      local search_nvim_config_files = function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end

      local search_grep_local_files = function()
        -- It's also possible to pass additional configuration options.
        -- See `:help telescope.builtin.live_grep()` for information about particular keys
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end

      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>s/', search_grep_local_files, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set('n', '<leader>sa', builtin.search_history, { desc = '[S]earch se[A]rch history' })
      vim.keymap.set('n', '<leader>sc', builtin.command_history, { desc = '[S]earch [C]ommand history' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>se', builtin.live_grep, { desc = '[S]earch by gr[E]p' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>si', builtin.registers, { desc = '[S]earch reg[I]sters' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sn', search_nvim_config_files, { desc = '[S]earch [N]eovim files' })
      vim.keymap.set('n', '<leader>so', require('telescope').extensions.notify.notify, { desc = '[S]earch n[O]tifications' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>st', require('git_grep').live_grep, { desc = '[S]earch by gi[T] grep' })
      vim.keymap.set('n', '<leader>su', require('telescope').extensions.undo.undo, { desc = '[S]earch [U]ndo tree' })
      vim.keymap.set('n', '<leader>sv', builtin.vim_options, { desc = '[S]earch [V]im options' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })

      -- Not the nicest to have a global function described here, but I could
      -- not find a better way to invoke a command that is able to use the
      -- ranged mark, as we must <esc> before invoking the function, which is
      -- not trivial apparently.
      function TelescopeRangedBcommit()
        builtin.git_bcommits_range {
          from = vim.api.nvim_buf_get_mark(0, '<')[1],
          to = vim.api.nvim_buf_get_mark(0, '>')[1],
        }
      end

      local advanced_git_search = require('telescope').extensions.advanced_git_search

      vim.keymap.set('n', '<leader>sgb', builtin.git_branches, { desc = '[S]earch [G]it [B]ranches' })
      vim.keymap.set('n', '<leader>sgc', advanced_git_search.diff_branch_file, { desc = '[S]earch [G]it log [C]ontent' })
      vim.keymap.set('n', '<leader>sgd', advanced_git_search.diff_branch_file, { desc = '[S]earch [G]it [D]iff for file' })
      vim.keymap.set('n', '<leader>sgf', builtin.git_files, { desc = '[S]earch [G]it [F]iles' })
      vim.keymap.set('n', '<leader>sgh', advanced_git_search.changed_on_branch, { desc = '[S]earch [G]it files c[h]anged in current branch' })
      vim.keymap.set('n', '<leader>sgl', builtin.git_commits, { desc = '[S]earch [G]it [L]og (commits)' })
      vim.keymap.set('n', '<leader>sgs', builtin.git_status, { desc = '[S]earch [G]it [S]tatus' })
      vim.keymap.set('n', '<leader>sgu', builtin.git_bcommits, { desc = '[S]earch [G]it b[U]ffer commits' })
      vim.keymap.set('v', '<leader>sgu', '<esc><cmd>lua TelescopeRangedBcommit()<cr>', { desc = '[S]earch [G]it b[U]ffer commits' })

      --[[
      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      --]]
    end,
  },
}
