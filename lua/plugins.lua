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
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
	},
	{ 'mg979/vim-visual-multi', branch = 'master' },
	'numToStr/Comment.nvim',
	'lewis6991/gitsigns.nvim',
	{ 'sindrets/diffview.nvim' },
	{
		'nvim-treesitter/nvim-treesitter',
		-- tag = "v0.9.0",
		build = ':TSUpdate',
	},
	-- 'lukas-reineke/indent-blankline.nvim',
	{
		'neovim/nvim-lspconfig',
		-- tag = "v0.1.4",
	},
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-path',
	{
		'L3MON4D3/LuaSnip',
		event = "BufRead",
		config = function() require('lazyConfigs/luasnip') end,
	},
	'rafamadriz/friendly-snippets',
	'saadparwaiz1/cmp_luasnip',
	{
		'kyazdani42/nvim-tree.lua', 
		dependencies = {
			'kyazdani42/nvim-web-devicons',
		},
		event = "VimEnter",
		config = function() require('lazyConfigs/nvimtree') end,
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
		config = function() require('lazyConfigs/tools') end,
	},
	{
		'ggandor/leap.nvim',
		event = "BufRead",
		config = function() require('lazyConfigs/leap') end,
	},
	'ray-x/lsp_signature.nvim',
	-- 'lvimuser/lsp-inlayhints.nvim',
	{
		'mfussenegger/nvim-lint',
		ft = {'python'},
	},
	-- Tech Stack Specific Plugins
	{
		'sebdah/vim-delve',
		ft = {'go'},
		config = function()
			require('lazyConfigs/go')
			require('lazyConfigs/inlay')
		end,
	},
	{
		'buoto/gotests-vim',
		ft = {'go'},
	},
	{
		'jose-elias-alvarez/typescript.nvim',
		ft = {'typescript', 'javascript'},
		config = function()
			require('lazyConfigs/ts')
			require('lazyConfigs/inlay')
		end,
	},
	{
		'simrat39/rust-tools.nvim',
		ft = {'rust'},
		config = function()
			require('lazyConfigs/rust')
			require('lazyConfigs/inlay')
		end,
	},
	{
		'saecki/crates.nvim',
		event = { "BufRead Cargo.toml" },
		config = function()
			require('crates').setup()
		end,
	},
	{
		dir = '~/.config/nvim/lua/lazyConfigs/python.lua',
		ft = {'python'},
		config = function() require('lazyConfigs/python') end,
	},
	{
		dir = '~/.config/nvim/lua/lazyConfigs/bash.lua',
		ft = {'sh'},
		config = function()
			require('lazyConfigs/bash')
			require('lazyConfigs/inlay')
		end,
	},
	{
		dir = '~/.config/nvim/lua/lazyConfigs/c.lua',
		ft = {'c', 'cpp'},
		config = function()
			require('lazyConfigs/c')
			require('lazyConfigs/inlay')
		end,
	},
	{
		dir = '~/.config/nvim/lua/lazyConfigs/sql.lua',
		ft = {'sql'},
		config = function() require('lazyConfigs/sql') end,
	},
	{
		'puremourning/vimspector',
		ft = {'go', 'rust', 'c', 'cpp'},
	} -- Ensure you have python3 imported
})
