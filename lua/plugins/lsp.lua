return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- mason must be set up first: it puts the servers it installs on PATH
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })

      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

      -- Neovim already maps K (hover), [d / ]d (diagnostics), <C-s> in insert (signature help),
      -- grn (rename), gra (code action), grr (references), gri (implementation), grt (type definition).
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("gr", vim.lsp.buf.references, "References")
          map("gC", vim.lsp.buf.incoming_calls, "Callers")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("gv", function()
            vim.cmd("vsplit")
            vim.lsp.buf.definition()
          end, "Definition in vsplit")
          map("gh", function()
            vim.cmd("split")
            vim.lsp.buf.definition()
          end, "Definition in split")
        end,
      })

      local servers = {
        gopls = {
          -- In the Olympus monorepo, scope each gopls to the service directory
          -- (e.g. Olympus/payment) instead of the whole module.
          root_dir = function(bufnr, on_dir)
            local modroot = vim.fs.root(bufnr, { "go.work", "go.mod" })
            if not modroot then
              return
            end
            local gomod = io.open(modroot .. "/go.mod")
            local first = gomod and gomod:read("*l") or ""
            if gomod then
              gomod:close()
            end
            local path = vim.api.nvim_buf_get_name(bufnr)
            local service = path:sub(#modroot + 2):match("^([^/]+)/")
            if first:find("Easypay/Olympus", 1, true) and service then
              on_dir(modroot .. "/" .. service)
              return
            end
            on_dir(modroot)
          end,
          settings = {
            gopls = {
              expandWorkspaceToModule = false,
              directoryFilters = {
                "-vendor",
                "-.git",
                "-.claude",
                "-**/node_modules",
                "-legacy",
                "-mbcp",
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
            },
          },
        },
        ts_ls = {},
        yamlls = { settings = { yaml = { schemas = {} } } },
        lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
        intelephense = { settings = { intelephense = { files = { maxSize = 5000000 } } } },
        clangd = {},
      }

      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
      end
      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },

  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        -- LSP servers
        "gopls",
        "rust-analyzer",
        "typescript-language-server",
        "lua-language-server",
        "intelephense",
        "clangd",
        "yaml-language-server",
        "jdtls", -- started by nvim-jdtls (java.lua), not vim.lsp.enable
        -- Linters and formatters
        "yamllint",
        "stylua",
        "prettier",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, pkg = pcall(registry.get_package, tool)
          if not ok then
            vim.notify("mason: unknown package " .. tool, vim.log.levels.WARN)
          elseif not pkg:is_installed() then
            pkg:install()
          end
        end
      end)
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      -- Rust is linted by rust-analyzer (clippy on save), so it is not listed here
      lint.linters_by_ft = {
        yaml = { "yamllint" },
      }
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
