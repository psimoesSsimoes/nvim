return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
        lua = { "stylua" },
        go = { "goimports" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        yaml = { "prettier" },
      },
      -- goimports can take a while on the first run in a large module
      format_on_save = {
        timeout_ms = 2000,
        lsp_format = "fallback",
      },
    },
  },
}
