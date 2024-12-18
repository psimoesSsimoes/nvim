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
-- Function to move lines
local function move_line(direction)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_nr = cursor[1]
  local line = vim.api.nvim_buf_get_lines(0, line_nr - 1, line_nr, false)[1]
  
  if direction == "up" and line_nr > 1 then
    vim.api.nvim_buf_set_lines(0, line_nr - 1, line_nr, false, {})
    vim.api.nvim_buf_set_lines(0, line_nr - 2, line_nr - 2, false, {line})
    vim.api.nvim_win_set_cursor(0, {line_nr - 1, cursor[2]})
  elseif direction == "down" and line_nr < vim.api.nvim_buf_line_count(0) then
    vim.api.nvim_buf_set_lines(0, line_nr - 1, line_nr, false, {})
    vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, {line})
    vim.api.nvim_win_set_cursor(0, {line_nr + 1, cursor[2]})
  end
end

-- Keymaps for moving lines
vim.keymap.set('n', '<leader><Up>', function() move_line('up') end, { desc = 'Move line up' })
vim.keymap.set('n', '<leader><Down>', function() move_line('down') end, { desc = 'Move line down' })

-- Also add visual mode support for moving multiple lines
vim.keymap.set('v', '<leader><Up>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('v', '<leader><Down>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })

-- Disable arrow keys
map('n', '<Up>', '<NOP>')
map('n', '<Down>', '<NOP>')
map('n', '<Left>', '<NOP>')
map('n', '<Right>', '<NOP>')

-- Function to get git root directory
local function get_git_root()
  local git_cmd = io.popen('git rev-parse --show-toplevel 2> /dev/null')
  if git_cmd == nil then 
    print("Failed to run git command")
    return nil 
  end
  
  local git_root = git_cmd:read('*l')
  git_cmd:close()
  print("Git root:", git_root)
  return git_root
end

-- Search word under cursor in git root
vim.keymap.set('n', '<leader>z', function()
  local word = vim.fn.expand('<cword>')
  local git_root = get_git_root()
  
  if git_root then
    -- Use live_grep instead of grep_string for more reliable results
    require('telescope.builtin').live_grep({
      default_text = word,
      cwd = git_root,
      prompt_title = 'Search "' .. word .. '" in Git Root',
      additional_args = function()
        return { "--hidden" }  -- Include hidden files
      end,
    })
  else
    vim.notify('Not in a git repository', vim.log.levels.WARN)
  end
end, { desc = 'Search word under cursor in git root' })

-- Add a test keymap to verify git root searching
vim.keymap.set('n', '<leader>zz', function()
  local git_root = get_git_root()
  if git_root then
    require('telescope.builtin').find_files({
      cwd = git_root,
      prompt_title = 'Files in Git Root',
      hidden = true,  -- Include hidden files
    })
  else
    vim.notify('Not in a git repository', vim.log.levels.WARN)
  end
end, { desc = 'List all files in git root' })

-- Find files in current file's directory
vim.keymap.set('n', '<leader>fc', function()
    require('telescope.builtin').find_files({
        cwd = vim.fn.expand('%:p:h'),
        prompt_title = 'Files in current directory',
    })
end, { desc = 'Find files in current directory' })
