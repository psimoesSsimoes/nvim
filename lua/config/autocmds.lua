local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings
local general = augroup('General', { clear = true })

-- Relative number toggle
autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' }, {
  group = general,
  pattern = '*',
  command = 'set relativenumber'
})

autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter' }, {
  group = general,
  pattern = '*',
  command = 'set norelativenumber'
})

-- Filetype specific settings
local filetypes = augroup('Filetypes', { clear = true })

autocmd('FileType', {
  group = filetypes,
  pattern = { 'go' },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

autocmd('FileType', {
  group = filetypes,
  pattern = { 'javascript', 'typescript', 'json', 'yaml' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
