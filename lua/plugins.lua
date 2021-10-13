return require('packer').startup(function()
use 'wbthomason/packer.nvim'
use 'hoob3rt/lualine.nvim'
use 'romgrk/barbar.nvim'
use { 'mg979/vim-visual-multi', branch = 'master' }
use 'preservim/nerdcommenter'
use 'tpope/vim-fugitive'
use { 'junegunn/fzf',  run = './install --bin' }
use 'junegunn/fzf.vim'
use 'airblade/vim-gitgutter'
use 'tpope/vim-rhubarb'
use 'numToStr/FTerm.nvim'
use 'sebdah/vim-delve'
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
use 'nvim-treesitter/playground'
use 'lukas-reineke/indent-blankline.nvim'
use 'neovim/nvim-lspconfig'
use 'nvim-lua/lsp_extensions.nvim'
use 'nvim-lua/lsp-status.nvim'
use 'hrsh7th/nvim-cmp'
use 'hrsh7th/cmp-nvim-lsp'
use 'L3MON4D3/LuaSnip'
use 'saadparwaiz1/cmp_luasnip'
use 'kyazdani42/nvim-tree.lua'
use 'kyazdani42/nvim-web-devicons'
use 'folke/trouble.nvim'
use 'shaunsingh/nord.nvim'
use 'psliwka/vim-smoothie'
use 'ellisonleao/glow.nvim'
use { 'kevinhwang91/nvim-bqf', branch = 'dev' }
end)
