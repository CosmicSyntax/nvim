return require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'nvim-lualine/lualine.nvim' 
	use { 'windwp/nvim-autopairs', config = function() require'nvim-autopairs'.setup() end }
	use 'akinsho/bufferline.nvim'
	use { 'mg979/vim-visual-multi', branch = 'master' }
	use { 'numToStr/Comment.nvim', config = function() require'Comment'.setup() end }
	use { 'junegunn/fzf',  run = './install --bin' }
	use 'junegunn/fzf.vim'
	use 'lewis6991/gitsigns.nvim'
	use 'tpope/vim-rhubarb'
	use 'tpope/vim-fugitive'
	use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function() require'nvim-tree'.setup() end }
	use 'lukas-reineke/indent-blankline.nvim'
	use 'neovim/nvim-lspconfig'
	use 'nvim-lua/lsp_extensions.nvim'
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
	-- Development Specific Plugins
	use 'sebdah/vim-delve'
	use 'buoto/gotests-vim'
	use { 'michaelb/sniprun', run = 'bash ./install.sh'}
end)
