return {
  { 'omrisarig13/vim-tab-movements', event = 'VeryLazy' },
  'jeffkreeftmeijer/vim-numbertoggle',
  { 'tpope/vim-abolish',             event = 'VeryLazy' },
  {
    'rcarriga/nvim-notify',
    config = function()
      notify = require 'notify'
      notify.setup {
        top_down = true,
        background_colour = "#000000",
      }

      vim.keymap.set('n', '<leader>nd', notify.dismiss, { desc = '[N]otifications [D]ismiss' })
    end,
  },
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
  -- Lualine {{{
  -- Adds ~60ms load time...
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'folke/trouble.nvim', 'nvim-tree/nvim-web-devicons', 'dpetka2001/noice.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        -- The following line is needed to fix the background color
        -- Set it to the lualine section you want to use
        hl_group = "lualine_c_normal",
      })

      local path_from_root = {
        function()
          local Path = require 'plenary.path'
          local git_root = Path:new(vim.fn.expand '%:p'):find_upwards '.git'
          if git_root then
            local root = git_root:parent():absolute()
            local file = vim.fn.expand '%:p'
            local path = Path:new(file):parent():make_relative(root)
            if path == '.' then
              return ''
            else
              return path
            end
          else
            return ''
          end
        end,
        icon = '',
        shorting_target = 40,
      }
      local cwd_from_repo_root = {
        function()
          local Path = require 'plenary.path'
          local cwd = vim.loop.cwd()
          local git_root = Path:new(cwd):find_upwards '.git'
          if git_root then
            local root = git_root:parent():absolute()
            local path = Path:new(cwd):make_relative(root)
            if path == '.' then
              return ''
            else
              return path
            end
          else
            return ''
          end
        end,
        icon = '',
        shorting_target = 40,
      }
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { path_from_root, { 'filename', icon = '' }, cwd_from_repo_root, {symbols.get, cond=symbols.has} },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = {
            {
              require('noice').api.status.mode.get,
              cond = require('noice').api.status.mode.has,
            },
          },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = { 'branch' },
          lualine_c = { path_from_root, 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
  -- Lualine }}}
  -- Noice {{{
  -- Adds a minimum of 60ms to startup, and sometimes up to 500ms????
  {
    'folke/noice.nvim',
    -- 'dpetka2001/noice.nvim',
    -- branch = 'fix/msg_show.shell_out',
    event = 'VeryLazy',
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      { 'MunifTanjim/nui.nvim', event = 'VeryLazy' },
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      { 'rcarriga/nvim-notify', event = 'VeryLazy' },
    },
    config = function()
      require('noice').setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          -- bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
      }
    end,
  },
  -- Noice }}}
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xa",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xb",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xl",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
