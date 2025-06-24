-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before lazy
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = "silent! lcd %:p:h"
})


-- Load core configurations
require("config.options")
require("config.keymaps")
require("config.autocmds")
-- require('lspconfig')

-- require'lspconfig'.intelephense.setup{
--   settings = {
--     intelephense = {
--       files = {
--         maxSize = 5000000; -- Increase max file size if needed (in bytes)
--       }
--     }
--   }
-- }


-- Initialize lazy.nvim
require("lazy").setup("plugins", {
  change_detection = { notify = false },
  install = { colorscheme = { "codedark" } },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})

vim.api.nvim_create_user_command('GoplsShowExcludedDirs', function()
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == "gopls" then
      local filters = client.config.settings and client.config.settings.gopls and client.config.settings.gopls.directoryFilters
      if filters then
        print("gopls excluded dirs: " .. table.concat(filters, ", "))
      else
        print("No gopls directoryFilters set or found.")
      end
      return
    end
  end
  print("No active gopls LSP client found!")
end, {})


return {
  -- Plugin manager
  { 'folke/lazy.nvim' },

  -- Dependencies
  { 'nvim-lua/plenary.nvim' },
  { 'MunifTanjim/nui.nvim' },

  -- Load plugin configs
  { import = 'plugins.editor' },
  { import = 'plugins.coding' },
  { import = 'plugins.ui' },
  { import = 'plugins.git' },
  { import = 'plugins.go' },
  { import = 'plugins.lsp' },
  { import = 'plugins.telescope' },
  -- https://github.com/LazyVim/LazyVim/issues/6039
  -- temporary workaround for mason.nvim? 
  -- { import = 'plugins.mason-workaround' },
  -- { import = 'plugins.notes' },
}
