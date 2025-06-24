-- Add this at the top to declare vim as a global
---@diagnostic disable: undefined-global

return {
  -- LSP Support
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      -- Configure diagnostics first
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      local lspconfig = require('lspconfig')
      -- Global mappings
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      -- Use LspAttach autocommand
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<C-r>', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                  -- Add vertical split definition
          vim.keymap.set('n', 'gv', function()
            vim.cmd('vsplit')
            vim.lsp.buf.definition()
          end, opts)
            -- Add horizontal split definition
          vim.keymap.set('n', 'gh', function()
            vim.cmd('split')
            vim.lsp.buf.definition()
          end, opts)
        end,
      })

      -- Configure servers
      local servers = {
        gopls = {
             directoryFilters = {
          "-vendor",
          "-.git",
          "-node_modules",
        },
        },
        rust_analyzer = {},
        ts_ls = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.yml",
                -- Add more schemas as needed
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' } -- Add vim to known globals
              }
            }
          }
        },
        intelephense = { -- Add this block
          settings = {
            intelephense = {
                files = {
                  maxSize = 5000000, -- Increase max file size if needed
                },
            },
          },
        },
        clangd = {
            -- root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git", "CMakeLists.txt"),
        }, -- <-- adiciona isto
      }

      for server, config in pairs(servers) do
        lspconfig[server].setup(config)
      end
    end,
  },

  -- Mason
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
    opts = {
      ensure_installed = {
        'gopls',
        'rust-analyzer',
        'typescript-language-server',
        'lua-language-server',
        'intelephense',
        'clangd', -- <-- aqui
        'yaml-language-server', -- Add this
        'yamllint', -- Add this
        'stylua', -- Lua formatter
        'prettier', -- Multi-language formatter
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  -- Mason LSP config
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {
        'lua_ls',
        'gopls',
        'rust_analyzer',
        'ts_ls',
        'intelephense',
        'clangd', -- <-- aqui
        'yamlls', -- Add this
      },
      automatic_installation = true,
      -- automatic_enable = false, -- Explicitly disable automatic enabling
    },
  },

  {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    
    -- Configure linters by filetype
    lint.linters_by_ft = {
      yaml = { "yamllint" },
    }
    
    -- Auto-lint on save and text changes
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
},
}
