return {
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
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { lua = true, kotlin = true, java = true, python = true }
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
        lua = { 'luaformatter' },
        -- Conform can also run multiple formatters sequentially
        python = { 'black' },
        -- python = { 'isort', 'black' },
        c = { 'clang-format' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        -- java = { 'eclipse_format', 'tab_to_spaces_format' },
        -- java = { 'google-java-format', 'tab2_to_tab4_format' },
        -- java = { 'configurable_java_format' },
        java = { 'clang-format' },
      },
      formatters = {
        eclipse_format = {
          command = '/scratch/omsi/toolsuites/gearbox/eclipseg/eclipse-for-gearbox-4.16.0-jre8u202/eclipse',
          inherit = false,
          args = {
            '-noSplash',
            '-application',
            'org.eclipse.jdt.core.JavaCodeFormatter',
            '-config',
            '/scratch/omsi/quantum/repo/tools/wombat/OticonJavaStyle2.xml',
            '$FILENAME',
          },
          stdin = false,
        },
        tab_to_spaces_format = {
          command = 'expand',
          args = { '-t', '4' },
        },
        tab2_to_tab4_format = {
          command = 'awk',
          args = { [[{ match($0, /^ */); lead=substr($0, 1, RLENGTH); rest=substr($0, RLENGTH+1); gsub(/  /, "    ", lead); print lead rest }]] },
        },
        configurable_java_format = {
          command = 'java',
          args = {
            '-jar',
            os.getenv 'HOME' .. '/Programs/formatters/configurable-google-java-format-2025.21.2-all-deps.jar',
            '-a',
            '--width',
            '150',
            '-',
          },
          stdin = true,
        },
      },
    },
  },
  -- Autoformat }}}
}

-- vim: foldmethod=marker
