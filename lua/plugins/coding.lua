return {
  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    build = "make install_jsregexp",
    config = function()
      require('luasnip').setup({
        history = true,
        update_events = 'TextChanged,TextChangedI',
      })
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },

  -- Comments
  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'v' } },
      { 'gb', mode = { 'n', 'v' } },
    },
    opts = {},
  },

  -- GitHub Copilot
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap('i', '<C-J>', 'copilot#Accept("<CR>")', 
        { silent = true, expr = true })
    end,
  },
}
