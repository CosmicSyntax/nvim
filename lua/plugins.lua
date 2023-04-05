-- Bootstrap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	'windwp/nvim-autopairs',
	'akinsho/bufferline.nvim',
	{ 'mg979/vim-visual-multi', branch = 'master' },
	'numToStr/Comment.nvim',
	'lewis6991/gitsigns.nvim',
	{ 'sindrets/diffview.nvim' },
	{ 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
	'lukas-reineke/indent-blankline.nvim',
	'neovim/nvim-lspconfig',
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-path',
	{
		'L3MON4D3/LuaSnip',
		event = "BufRead",
		config = function() require('configs/luasnip') end,
	},
	'rafamadriz/friendly-snippets',
	'saadparwaiz1/cmp_luasnip',
	{
		'kyazdani42/nvim-tree.lua', 
		dependencies = {
			'kyazdani42/nvim-web-devicons',
		},
		event = "VimEnter",
		config = function() require('configs/nvimtree') end,
	},
	'elihunter173/dirbuf.nvim',
	'folke/trouble.nvim',
	-- 'rmehri01/onenord.nvim',
	'arcticicestudio/nord-vim',
	'karb94/neoscroll.nvim',
	'kevinhwang91/nvim-bqf',
	'anuvyklack/windows.nvim',
	'anuvyklack/middleclass',
	'onsails/lspkind-nvim',
	'nvim-telescope/telescope.nvim',
	{'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	'nvim-telescope/telescope-ui-select.nvim',
	'nvim-lua/plenary.nvim',
	'kdheepak/lazygit.nvim',
	{
		'ruifm/gitlinker.nvim',
		event = "BufRead",
		config = function() require('configs/tools') end,
	},
	'ray-x/lsp_signature.nvim',
	'lvimuser/lsp-inlayhints.nvim',
	{
		'jose-elias-alvarez/null-ls.nvim',
		ft = {'python'},
	},
	-- Tech Stack Specific Plugins
	{
		'sebdah/vim-delve',
		ft = {'go'},
		config = function() require('configs/go') end,
	},
	{
		'buoto/gotests-vim',
		ft = {'go'},
	},
	{
		'jose-elias-alvarez/typescript.nvim',
		ft = {'typescript'},
		config = function() require('configs/ts') end,
	},
	{
		'simrat39/rust-tools.nvim',
		ft = {'rust'},
		config = function() require('configs/rust') end,
	},
	{
		'saecki/crates.nvim',
		event = { "BufRead Cargo.toml" },
		config = function()
			require('crates').setup()
		end,
	},
	{
		dir = '~/.config/nvim/lua/configs/python.lua',
		ft = {'python'},
		config = function() require('configs/python') end,
	},
	{
		dir = '~/.config/nvim/lua/configs/bash.lua',
		ft = {'sh'},
		config = function() require('configs/bash') end,
	},
	{
		dir = '~/.config/nvim/lua/configs/c.lua',
		ft = {'c', 'cpp'},
		config = function() require('configs/c') end,
	},
	'puremourning/vimspector' -- Ensure you have python3 imported
})
