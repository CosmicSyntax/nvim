return require('packer').startup(function()
use 'wbthomason/packer.nvim'
use 'nvim-lualine/lualine.nvim' 
use 'windwp/nvim-autopairs'
use 'akinsho/bufferline.nvim'
use { 'mg979/vim-visual-multi', branch = 'master' }
use 'preservim/nerdcommenter'
use { 'junegunn/fzf',  run = './install --bin' }
use 'junegunn/fzf.vim'
use 'airblade/vim-gitgutter'
use 'tpope/vim-rhubarb'
use 'tpope/vim-fugitive'
use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
use 'akinsho/toggleterm.nvim'
use 'sebdah/vim-delve'
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
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
use 'EdenEast/nightfox.nvim'
use 'karb94/neoscroll.nvim'
use 'kevinhwang91/nvim-bqf'
use 'szw/vim-maximizer'
use 'buoto/gotests-vim'
end)
