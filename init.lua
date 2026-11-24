-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader must be set before lazy loads plugins
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config.options")
require("config.keymaps")
require("config.autocmds")

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
