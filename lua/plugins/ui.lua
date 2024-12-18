return {
  -- Colorscheme
  {
    'tomasiser/vim-code-dark',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('codedark')
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'codedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPost',
    opts = {
      char = '│',
      show_trailing_blankline_indent = false,
      show_first_indent_level = false,
    },
  },

  -- Better diagnostics
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = {
      use_diagnostic_signs = true,
    },
    keys = {
      { '<leader>xx', '<cmd>TroubleToggle<cr>', desc = 'Toggle diagnostics' },
    },
  },
}
