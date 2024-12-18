local map = vim.keymap.set

-- Better window navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })

-- Center screen
map('n', '<space>', 'zz', { desc = 'Center screen' })

-- Remove search highlight
map('n', '<leader><space>', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Tabs
map('n', '<leader>1', '1gt', { desc = 'Go to tab 1' })
map('n', '<leader>2', '2gt', { desc = 'Go to tab 2' })
map('n', '<leader>3', '3gt', { desc = 'Go to tab 3' })
map('n', '<leader>4', '4gt', { desc = 'Go to tab 4' })

-- Quick save
map('n', '<leader>w', ':w!<CR>', { desc = 'Save file' })
map('n', '<leader>q', ':q!<CR>', { desc = 'Quit' })

-- Exit insert mode
map('i', 'jk', '<ESC>', { desc = 'Exit insert mode' })

-- Move lines
map('n', '<leader><Up>', ':call v:lua.swap_up()<CR>', { silent = true })
map('n', '<leader><Down>', ':call v:lua.swap_down()<CR>', { silent = true })

-- Disable arrow keys
map('n', '<Up>', '<NOP>')
map('n', '<Down>', '<NOP>')
map('n', '<Left>', '<NOP>')
map('n', '<Right>', '<NOP>')
