return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- init.lua lcd's into each file's directory; start Claude at the repo root instead
      terminal = { git_repo_cwd = true },
    },
    init = function()
      -- Make <C-w> window commands work straight from the Claude terminal, and land in insert mode when coming back.
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*claude*",
        callback = function(ev)
          vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { buffer = ev.buf, desc = "Window command from Claude" })
          vim.api.nvim_create_autocmd("BufEnter", { buffer = ev.buf, command = "startinsert" })
        end,
      })
    end,
    keys = {
      { "<leader>ic", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>if", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ib", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current file to Claude" },
      { "<leader>is", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>iy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>in", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude diff" },
    },
  },
}
