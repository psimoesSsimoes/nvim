local opt = vim.opt

-- General
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.completeopt = "menu,menuone,noselect"
opt.undofile = true
opt.undodir = vim.fn.expand("~/.cache/nvim/undodir")

-- UI
opt.number = true
opt.relativenumber = true
opt.showmatch = false
opt.cursorline = false
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 300
opt.timeoutlen = 500
opt.list = false
opt.listchars = { tab = "▸ ", eol = "¬" }

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Colors
opt.termguicolors = true
