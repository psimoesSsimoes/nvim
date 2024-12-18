return {
  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    keys = {
      { '<leader>n', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle file explorer' },
    },
    opts = {
      filters = {
        dotfiles = false,
      },
    },
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
      { '<leader>f', '<cmd>Telescope find_files<CR>', desc = 'Find files' },
      { '<leader>g', '<cmd>Telescope live_grep<CR>', desc = 'Live grep' },
      { '<leader>b', '<cmd>Telescope buffers<CR>', desc = 'Buffers' },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { 'node_modules', '.git' },
        layout_strategy = 'horizontal',
        layout_config = { preview_width = 0.6 },
      },
    },
  },

  -- Better quickfix
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  },
}
