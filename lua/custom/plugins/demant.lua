return {
  {
    dir = '/home/omsi/.config/nvim-kickstart/pack/demant/start/demant/',
    lazy = false,
  },
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = {
  --     "nvim-neotest/nvim-nio",
  --     "nvim-lua/plenary.nvim",
  --     "antoinemadec/FixCursorHold.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "alfaix/neotest-gtest",
  --     { url = "ssh://git@gitlab.ci.demant.com:42022/auly/neotest-quantum.git" },
  --   },
  --   keys = {
  --     { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "NeoTest: Toggle Summary" },
  --     { "<leader>tr", function() require("neotest").run.run() end,                                        desc = "NeoTest: Run Nearest Test" },
  --     { "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "NeoTest: Run Current File" },
  --     { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end,                         desc = "NeoTest: Run All Tests" },
  --     { "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "NeoTest: Run Last Test" },
  --     { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,                    desc = "NeoTest: Debug Nearest Test" },
  --     { "<leader>tD", function() require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" }) end, desc = "NeoTest: Debug File" },
  --     { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "NeoTest: Show Output" },
  --     { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "NeoTest: Toggle Output Panel" },
  --     { "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "NeoTest: Stop Running Tests" },
  --     { "<leader>tw", function() require("neotest").watch.toggle() end,                                   desc = "NeoTest: Toggle Watch Mode" },
  --     { "<leader>tW", function() require("neotest").watch.toggle(vim.fn.expand("%")) end,                 desc = "NeoTest: Toggle Watch File" },
  --     { "<leader>tj", function() require("neotest").jump.next({ status = "failed" }) end,                 desc = "NeoTest: Jump to Next Failed" },
  --     { "<leader>tk", function() require("neotest").jump.prev({ status = "failed" }) end,                 desc = "NeoTest: Jump to Previous Failed" },
  --     { "<leader>tm", function() require("neotest").output.open({ enter = true, short = true }) end,      desc = "NeoTest: Show Short Output" },
  --   },
  --
  --   config = function()
  --     require('neotest').setup {
  --       adapters = {
  --         require('neotest-quantum').setup(),
  --       },
  --       floating = {
  --         max_height = 0.9,
  --         max_width = 0.9,
  --       },
  --     }
  --   end
  -- },
}
