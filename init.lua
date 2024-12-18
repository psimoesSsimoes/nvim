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

-- Load core configurations
require("config.options")
require("config.keymaps")
require("config.autocmds")

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
}
