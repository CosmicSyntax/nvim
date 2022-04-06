return require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use {'nvim-lualine/lualine.nvim'}
	use 'windwp/nvim-autopairs'
	use 'akinsho/bufferline.nvim'
	use { 'mg979/vim-visual-multi', branch = 'master' }
	use 'numToStr/Comment.nvim'
	use 'lewis6991/gitsigns.nvim'
	use 'tpope/vim-rhubarb'
	use 'tpope/vim-fugitive'
	use 'sindrets/diffview.nvim' 
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'lukas-reineke/indent-blankline.nvim'
	use 'neovim/nvim-lspconfig'
	use 'arkav/lualine-lsp-progress'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
	use 'folke/trouble.nvim'
	use 'rmehri01/onenord.nvim'
	use 'karb94/neoscroll.nvim'
	use 'kevinhwang91/nvim-bqf'
	use 'szw/vim-maximizer'
	use 'onsails/lspkind-nvim'
	use 'nvim-telescope/telescope.nvim'
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use 'nvim-telescope/telescope-ui-select.nvim'
	use 'nvim-lua/plenary.nvim'
	-- use 'jose-elias-alvarez/null-ls.nvim'
	-- Tech Stack Specific Plugins
	use 'sebdah/vim-delve'
	use 'buoto/gotests-vim'
	use 'jose-elias-alvarez/nvim-lsp-ts-utils'
	use 'simrat39/rust-tools.nvim'
	use 'puremourning/vimspector' -- Ensure you have python3 imported
end)
