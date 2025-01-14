return {
  {
    'fatih/vim-go',
    ft = 'go',
    build = ':GoUpdateBinaries',
    config = function()
      -- Go settings
      vim.g.go_fmt_command = "goimports"
      vim.g.go_auto_type_info = 1
      vim.g.go_def_mode = 'gopls'
      vim.g.go_info_mode = 'gopls'
      
      -- Highlighting
      vim.g.go_highlight_types = 1
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_operators = 1
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_build_constraints = 1
      
      -- Mappings
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'go',
        callback = function()
          local opts = { buffer = true }
           -- Run only the test function under cursor with leader t
          vim.keymap.set('n', '<leader>t', '<cmd>GoTestFunc!<CR>', { desc = 'Run Go test function' })
          vim.keymap.set('n', '<leader>c', '<cmd>GoCoverageToggle<CR>', { desc = 'Toggle Go coverage' })
          
          -- Additional test-related mappings you might find useful
          vim.keymap.set('n', '<leader>ta', '<cmd>GoTest!<CR>', { desc = 'Run all tests in file' })
          vim.keymap.set('n', '<leader>tl', '<cmd>GoTestCompile<CR>', { desc = 'Test compile' })
            -- Definition mappings
          -- vim.keymap.set('n', 'gd', '<cmd>GoDef<CR>', { desc = 'Go to definition' })
          -- vim.keymap.set('n', '<leader>v', '<cmd>vsplit | GoDef<CR>', { desc = 'Go to definition in split' })
          -- vim.keymap.set('n', '<C-t>', '<C-o>', { desc = 'Go back from definition' })
           -- Build command
          vim.keymap.set('n', '<C-b>', '<cmd>GoBuild<CR>', { desc = 'Build Go project' })
        end,
      })
    end,
  },
} 
