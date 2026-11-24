return {
  {
    "fatih/vim-go",
    ft = "go",
    init = function()
      -- vim-go is kept for its commands (tests, coverage, alternate file, build).
      -- LSP features come from the native client (lsp.lua), formatting from conform (formatting.lua).
      vim.g.go_gopls_enabled = 0
      vim.g.go_code_completion_enabled = 0
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_doc_keywordprg_enabled = 0
      vim.g.go_auto_type_info = 0
      vim.g.go_fmt_autosave = 0
      vim.g.go_imports_autosave = 0
      vim.g.go_mod_fmt_autosave = 0

      vim.g.go_test_show_name = 1

      vim.g.go_highlight_types = 1
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_operators = 1
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_build_constraints = 1
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("GoMappings", { clear = true }),
        pattern = "go",
        callback = function(ev)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end

          map("<leader>t", "<cmd>GoTestFunc!<CR>", "Run Go test under cursor")
          map("<leader>ta", "<cmd>GoTest!<CR>", "Run Go tests in package")
          map("<leader>tl", "<cmd>GoTestCompile<CR>", "Compile Go tests")
          map("<leader>c", "<cmd>GoCoverageToggle<CR>", "Toggle Go coverage")
          map("<C-b>", "<cmd>GoBuild<CR>", "Build Go package")

          map("<leader>aa", "<Plug>(go-alternate-edit)", "Go alternate file")
          map("<leader>av", "<Plug>(go-alternate-vertical)", "Go alternate in vsplit")
          map("<leader>as", "<Plug>(go-alternate-split)", "Go alternate in split")

          -- vim-go's versions need its own gopls; route them to the native LSP
          vim.api.nvim_buf_create_user_command(ev.buf, "GoCallers", function() vim.lsp.buf.incoming_calls() end, {})
          vim.api.nvim_buf_create_user_command(ev.buf, "GoCallees", function() vim.lsp.buf.outgoing_calls() end, {})
        end,
      })
    end,
  },
}
