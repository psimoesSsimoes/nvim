local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

map("n", "<space>", "zz", { desc = "Center screen" })
map("n", "<leader><space>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Keep selection after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<leader>1", "1gt", { desc = "Go to tab 1" })
map("n", "<leader>2", "2gt", { desc = "Go to tab 2" })
map("n", "<leader>3", "3gt", { desc = "Go to tab 3" })
map("n", "<leader>4", "4gt", { desc = "Go to tab 4" })

map("n", "<leader>w", "<cmd>w!<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q!<CR>", { desc = "Quit without saving" })

map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Move lines
map("n", "<leader><Up>", "<cmd>move .-2<CR>==", { desc = "Move line up" })
map("n", "<leader><Down>", "<cmd>move .+1<CR>==", { desc = "Move line down" })
map("v", "<leader><Up>", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<leader><Down>", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })

map("n", "<Up>", "<NOP>")
map("n", "<Down>", "<NOP>")
map("n", "<Left>", "<NOP>")
map("n", "<Right>", "<NOP>")

-- Search from the git root (the working directory follows the current file, see autocmds.lua)
local function git_root()
  local root = vim.fs.root(0, ".git")
  if not root then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
  end
  return root
end

map("n", "<leader>z", function()
  local root = git_root()
  if not root then
    return
  end
  local word = vim.fn.expand("<cword>")
  require("telescope.builtin").live_grep({
    default_text = word,
    cwd = root,
    prompt_title = 'Search "' .. word .. '" in git root',
    additional_args = { "--hidden" },
  })
end, { desc = "Grep word under cursor in git root" })

map("n", "<leader>zz", function()
  local root = git_root()
  if not root then
    return
  end
  require("telescope.builtin").find_files({ cwd = root, prompt_title = "Files in git root", hidden = true })
end, { desc = "Find files in git root" })

map("n", "<leader>fc", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h"), prompt_title = "Files in current directory" })
end, { desc = "Find files in current directory" })

-- Replace the word under cursor (or the selection) everywhere in this file
map({ "n", "v" }, "<space>r", function()
  local word
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" then
    local saved = vim.fn.getreg("v")
    vim.cmd('normal! "vy')
    word = vim.fn.getreg("v")
    vim.fn.setreg("v", saved)
  else
    word = vim.fn.expand("<cword>")
  end

  local new_word = vim.fn.input("New name: ")
  if new_word == "" then
    return
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  local ok = pcall(vim.cmd, string.format("%%s/\\V%s/%s/g", vim.fn.escape(word, "/\\"), vim.fn.escape(new_word, "/\\&")))
  if not ok then
    vim.notify("No matches found", vim.log.levels.WARN)
  end
  vim.api.nvim_win_set_cursor(0, pos)
end, { desc = "Replace word in file" })
