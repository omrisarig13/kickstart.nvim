-- Intro {{{
--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]
-- Intro }}}

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = '-'

-- Enable nerd-font, as it is used.
vim.g.have_nerd_font = true

-- [[ Setting options ]] {{{
-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Disable mause, just annoying.
vim.o.mouse = ''

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  OMSA: Decide whether this functionality makes sense as default.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = false

--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
-- Show tabs, trailing spaces and multiple-spaces as characters, to be able to
-- quickly distinguish them. The laeding spaces are converted to regular spaces,
-- as they should not be shown differently (0x20 = space, as space cannot be set
-- directly there).
vim.opt.listchars = {
  tab = '<->',
  trail = '-',
  multispace = '.',
  lead = '\\x20',
}

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
-- OMSA: Look at this value again, decide if this is too much.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Break the lines at end of window, not spliting words.
vim.o.wrap = true
vim.o.linebreak = true
-- [[ Setting options ]] }}}

-- [[ TMP Setting Options ]] {{{
-- Some settings options which are considered temporary for now, they should be
-- re-evaluated in the future, when more time is available.
-- TODO: Change by file-type. {{{
-- Set textwidth to end at 80.
vim.o.textwidth = 79
-- Add a colored column at the end of wanted lines.
vim.o.colorcolumn = '+1'
-- TODO: Change by file-type. }}}
-- TODO: Temporary mapping, while still working on re-learning. {{{
-- vim.keymap.set('c', 'W', 'w', { desc = 'Save when using wrong letters.' })
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('Q', 'windo q', {})

local function format_table()
  -- Get start line
  vim.cmd 'normal! {j'
  local start_line = vim.fn.line '.'
  -- Remove header line, will be added again in the future
  vim.cmd 'normal! jdd'
  -- Get end line
  vim.cmd 'normal! }k'
  local end_line = vim.fn.line '.'
  -- Format the table
  -- Remove multiple spaces, to let the column command create the minimal
  -- needed columns
  vim.cmd(start_line .. ',' .. end_line .. 's/ \\+/ /ge')
  vim.cmd(start_line .. ',' .. end_line .. "!column -t -s '|' -o '|'")
  -- Re-create header
  vim.cmd 'normal! {jyyp' -- Create template for header line.
  vim.cmd 's/[^|]/-/g' -- Create dashes in header line
  vim.cmd 's/|-/| /g' -- Remove dashes after separators
  vim.cmd 's/-|/ |/g' -- Remove dashes before separators
end
vim.keymap.set('n', '<leader>pf', format_table, { desc = '[P]ersonal format [T]able' })

-- TODO: Temporary mapping, while still working on re-learning. }}}

-- TODO: Tab options, was not re-investigated yet. {{{
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.shiftround = true
-- TODO: Tab options, was not re-investigated yet. }}}

-- Set spell checking.
-- TODO: Update the spellfile location, and make it generated automatically in a
-- proper place.
vim.o.spell = true
vim.o.spelllang = 'en_us'
vim.o.spellfile = '/home/omsa/.config/nvim-kickstart/omsa-spell.utf-8.add'

vim.keymap.set('n', '<C-Right>', [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set('n', '<C-Left>', [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
vim.keymap.set('n', '<C-Up>', [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set('n', '<C-Down>', [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -

vim.cmd 'command! Lcdc lcd %:h'
vim.keymap.set('n', '<leader>pc', ':Lcdc<cr>', { desc = '[P]ersonal [C]hange directory' })

local function close_tabs_to_right()
  local current_tab_page = vim.fn.tabpagenr()

  local next_tab_info = vim.fn.gettabinfo(current_tab_page + 1)
  while next(next_tab_info) ~= nil do
    vim.cmd('tabclose ' .. (current_tab_page + 1))
    next_tab_info = vim.fn.gettabinfo(current_tab_page + 1)
  end
end
vim.keymap.set('n', '<leader>tr', close_tabs_to_right, { desc = '[T]ab close tabs to the [R]ight' })

local function close_tabs_to_left()
  local previous_tab_page = vim.fn.tabpagenr() - 1

  for i = previous_tab_page, 1, -1 do
    vim.cmd('tabclose ' .. i)
  end
end
vim.keymap.set('n', '<leader>tl', close_tabs_to_left, { desc = '[T]ab close tabs to the [L]eft' })
-- [[ TMP Setting Options ]] }}}

-- [[ Basic Keymaps ]] {{{
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  OMSA: Takes a bit of getting used to, but looks nice.
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Keymaps ]] }}}

-- [[ Basic Autocommands ]] {{{
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
-- TODO: Decide whether this makes sense, or just unnecessary.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
-- [[ Basic Autocommands ]] }}}

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
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  --
  -- OMSA: Looks like a good plugin, when the files are consistent. But,
  -- looking at the real word, this is not always the case. Some more
  -- investigation/testing should be done. It can be a good idea to figure out
  -- if I can manually load this plugin when wanted, instead of doing so
  -- automatically.
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do

  -- OMSA: Keep moving over the file from here down.

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin
  {
    'rcarriga/nvim-notify',
    opts = { top_down = true },
  },

  -- LSP Plugins {{{
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- LSP Plugins }}}
  -- Main LSP Configuration {{{
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {},
        -- gopls = {},
        pyright = {},
        bashls = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
      -- TODO: This will not work with the above system, but I could not figure
      -- out why/how. This should be investigated further.
      require('lspconfig').bitbake_ls.setup {}
      --[[ This adds a ton of error messages, so for now we don't want it.
      require('lspconfig').bitbake_language_server.setup {
        handlers = {
          ['window/showMessage'] = function(_, result, _)
            local message_type = result.type
            local message_text = result.message

            -- Only show ERROR (1) and WARN (2)
            if message_type == 1 or message_type == 2 then
              vim.notify(string.format('[bitbake] %s', message_text), message_type == 1 and vim.log.levels.ERROR or vim.log.levels.WARN)
            end
          end,
        },
      }
      --]]
    end,
  },
  -- Main LSP Configuration }}}

  { -- Autoformat {{{
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
  -- Autoformat }}}

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'dpetka2001/noice.nvim' },
    config = function()
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
          lualine_c = { 'filename' },
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
          lualine_b = {},
          lualine_c = { 'filename' },
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

  -- Noice {{{
  {
    -- 'folke/noice.nvim',
    'dpetka2001/noice.nvim',
    branch = 'fix/msg_show.shell_out',
    event = 'VeryLazy',
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
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
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
    end,
  },
  -- Noice }}}

  { -- Autocompletion {{{
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
      'dpetka2001/noice.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      cmdline = { completion = { menu = { auto_show = true } } },

      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',
        ['<C-e>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-j>'] = { 'scroll_documentation_up', 'fallback' },
        -- TODO: Update
        -- ['<C-space>'] = { 'fallback' }, -- c-space is used for copilot completion.
        -- Print the value of b:copilot_enabled in vimscript

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 5 },
        menu = {
          draw = {
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind' },
            },
          },
        },
        -- Display a preview of the selected item on the current line
        ghost_text = { enabled = false },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer', 'omni' },
        providers = {
          lsp = {
            fallbacks = {},
          },
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          -- Not sure if this is working or not, to test...
          buffer = {
            score_offset = -5,
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(function(bufnr)
                  return vim.bo[bufnr].buftype == ''
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      -- fuzzy = { implementation = 'lua' },
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
        sorts = {
          'exact',
          -- defaults
          'score',
          'sort_text',
        },
      },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  -- Autocompletion }}}

  -- todo-comments {{{
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('todo-comments').setup {
        signs = false,
        keywords = {
          OMSA = { icon = ' ', color = 'info' },
        },
      }
      vim.keymap.set('n', ']f', function()
        require('todo-comments').jump_next { keywords = { 'TODO', 'OMSA', 'FIXME' } }
      end, { desc = 'Next [F]ixme comment (TODO, FIXME, OMSA)' })
      vim.keymap.set('n', '[f', function()
        require('todo-comments').jump_prev { keywords = { 'TODO', 'OMSA', 'FIXME' } }
      end, { desc = 'Previous [F]ixme comment (TODO, FIXME, OMSA)' })
    end,
  },
  -- todo-comments }}}

  { -- Collection of various small independent plugins/modules {{{
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- 'tpope/vim-surround' equivalent.
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Session handling
      --
      -- 'tpope/vim-obsession' equivalent
      require('mini.sessions').setup()
      local sessions = require 'mini.sessions'
      vim.keymap.set('n', '<leader>isc', function()
        local session_name = sessions.config.file
        vim.cmd('mksession ' .. session_name)
      end, { desc = 'M[I]ni [S]ession [C]reate' })
      vim.keymap.set('n', '<leader>isr', sessions.read, { desc = 'M[I]ni [S]ession [R]ead' })
      vim.keymap.set('n', '<leader>isw', sessions.write, { desc = 'M[I]ni [S]ession [W]rite' })
      vim.keymap.set('n', '<leader>iss', sessions.select, { desc = 'M[I]ni [S]ession [S]elect' })
      vim.keymap.set('n', '<leader>isd', function()
        sessions.delete(nil, { force = true })
      end, { desc = 'M[I]ni [S]ession [D]edelet' })

      -- Better around/inside handling.
      --
      -- 'wellle/targets.vim'
      --
      -- - dan) - [D]elete [A]round [N]next [)]Paren
      require('mini.ai').setup()

      -- Alignment plugin
      --
      -- gaip= - Align = signs.
      -- [v]: gA= Align equal signs in selected visual.
      require('mini.align').setup()

      -- Move lines and selected text around
      require('mini.move').setup {
        mappings = {
          -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
          left = '<C-h>',
          right = '<C-l>',
          down = '<C-j>',
          up = '<C-k>',

          -- Move current line in Normal mode
          line_left = '<C-h>',
          line_right = '<C-l>',
          line_down = '<C-j>',
          line_up = '<C-k>',
        },
      }

      -- Some cool operators
      --
      -- - g=<operator> - evaluate
      -- - gx<operator> + . - exchange
      -- - gm<operator> - duplicate
      -- - gs<operator> - sort
      --
      -- replace is equivalent to 'inkarkat/vim-ReplaceWithRegister'
      require('mini.operators').setup {
        replace = {
          prefix = '<leader>r',
        },
      }

      -- Split and join function arguments, adds/removes newlines as wanted.
      --
      -- - gS split/join the arguments.
      require('mini.splitjoin').setup()

      -- Use the [] brackets to move around.
      require('mini.bracketed').setup()

      -- This is a different implementation for diff handling in nvim.
      -- Currently, I'm happy with the default handling, but this can be
      -- re-evaluated later, if more features are needed/wanted.
      -- require('mini.diff').setup()

      -- Better handling when opening directory as file.
      --
      -- Add mapping for easy open and close of the file explorer.
      require('mini.files').setup()
      vim.keymap.set('n', '<leader>if', MiniFiles.open, { desc = 'M[I]ni [F]ile explorer open' })
      vim.keymap.set('n', '<leader>ic', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
      end, { desc = 'M[I]ni file explorer open [C]urrent file' })
      vim.keymap.set('n', '<leader>ii', function()
        local file_path = vim.fn.input('Enter path to open:', '', 'file')
        MiniFiles.open(file_path)
      end, { desc = 'M[I]ni file explorer open [I]nputted path' })

      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local cur_target = MiniFiles.get_explorer_state().target_window
          local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(direction .. ' split')
            return vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target)

          -- This intentionally doesn't act on file under cursor in favor of
          -- explicit "go in" action (`l` / `L`). To immediately open file,
          -- add appropriate `MiniFiles.go_in()` call instead of this comment.
          MiniFiles.go_in()
          MiniFiles.close()
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak keys to your liking
          map_split(buf_id, '<C-s>', 'belowright horizontal')
          map_split(buf_id, '<C-v>', 'belowright vertical')
          map_split(buf_id, '<C-t>', 'tab')
          vim.keymap.set('n', '<cr>', function()
            local fs_entry = MiniFiles.get_fs_entry()

            if fs_entry == nil or fs_entry.fs_type == nil or fs_entry.path == nil then
              print 'Invalid fs_entry table'
              return
            end

            if fs_entry.fs_type == 'directory' then
              local current_window = vim.api.nvim_get_current_win()
              vim.cmd('windo lcd ' .. fs_entry.path)
              vim.api.nvim_set_current_win(current_window)
            elseif fs_entry.fs_type == 'file' then
              MiniFiles.go_in()
              MiniFiles.close()
            end
          end, { buffer = buf_id, desc = 'LCD to current directory' })
        end,
      })

      -- Highlight current word
      --
      -- Equivalent to vim_current_word
      require('mini.cursorword').setup()

      -- Highlight and remove trailing spaces.
      require('mini.trailspace').setup()
      vim.keymap.set('n', '<leader>it', MiniTrailspace.trim, { desc = 'M[I]ni [T]railspaces trim' })
      vim.keymap.set('n', '<leader>il', MiniTrailspace.trim_last_lines, { desc = 'M[I]ni trailspaces trim [L]ines' })

      -- todo-comments has more features than mini-hipatterns

      require('mini.icons').setup()

      -- Show indentation groups in a nice way.
      --
      -- Also solves the need for lukas-reineke/indent-blankline.nvim.
      require('mini.indentscope').setup()

      -- Show a short overview of the line length and indentation in the file
      require('mini.map').setup()
      vim.keymap.set('n', '<leader>im', MiniMap.toggle, { desc = 'M[I]ni [M]ap toggle' })

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  -- Collection of various small independent plugins/modules }}}
  { -- Highlight, edit, and navigate code {{{
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
  -- Highlight, edit, and navigate code }}}
  -- Temporary plugins: {{{
  {
    -- TODO: Read the docs, and understand if more options can be good.
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
  },
  -- Temporary plugins: }}}

  -- Next Steps {{{
  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.git',
  require 'kickstart.plugins.which-key',
  require 'kickstart.plugins.color',
  require 'kickstart.plugins.telescope',
  require 'custom.plugins.vim-port',
  require 'custom.plugins.flash',

  -- Copilot {{{
  --[[
  {
    'github/copilot.vim',
    config = function()
      -- Disabe by default, ask for specific suggestion with c-space.
      vim.cmd 'Copilot disable'
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
      vim.g.copilot_enabled = false
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
    end,
  },
  --]]
  -- Copilot }}}
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      require('snacks').setup {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = false },
        notifier = { enabled = false },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = true },
      }

      local snacks = require 'snacks'

      vim.keymap.set('n', '<leader>os', function()
        snacks.scratch()
      end, { desc = 'Snacks [S]cratch' })
      vim.keymap.set('n', '<leader>oc', snacks.scratch.select, { desc = 'Snacs s[c]ratch select' })
      vim.keymap.set('n', '<leader>or', snacks.rename.rename_file, { desc = 'Snacks [R]ename' })
      vim.keymap.set('n', '<leader>og', function()
        snacks.gitbrowse()
      end, { desc = 'Snacks [G]it browse (remote)' })
    end,
  },

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
  -- Next Steps }}}
}, {
  ui = { -- {{{
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
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

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
