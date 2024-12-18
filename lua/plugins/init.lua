return {
    -- Plugin manager
    { 'folke/lazy.nvim' },

    -- Essential plugins
    { 'nvim-lua/plenary.nvim' },
    
    -- Your existing plugins converted to lazy format
    { 'ekalinin/Dockerfile.vim' },
    { 'AndrewRadev/splitjoin.vim' },
    { 'Raimondi/delimitMate' },
    { 'fatih/vim-go' },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-commentary' },
    { 'tpope/vim-surround' },
    
    -- Fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- Colorscheme
    {
        'tomasiser/vim-code-dark',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('codedark')
        end,
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
    },

    -- Copilot
    { 'github/copilot.vim' },

    -- File explorer replacement for NERDTree
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('nvim-tree').setup()
        end,
    },
} 
