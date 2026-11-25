return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<leader>n", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    },
    opts = {
      filters = { dotfiles = false },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>g", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>?", "<cmd>Telescope keymaps<CR>", desc = "Shortcut cheatsheet" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          -- Lua patterns: "%." is a literal dot
          file_ignore_patterns = { "node_modules/", "%.git/" },
          path_display = { "truncate" },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.55,
              results_width = 0.8,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },

  { "kevinhwang91/nvim-bqf", ft = "qf" },

  { "tpope/vim-surround", event = "VeryLazy" },
  { "AndrewRadev/splitjoin.vim", keys = { "gS", "gJ" } },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
}
