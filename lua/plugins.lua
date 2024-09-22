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
		{
			'windwp/nvim-autopairs',
			event = "InsertEnter",
		},
		{
			-- LSP notification
			"j-hui/fidget.nvim",
			-- tag = "legacy",
			event = "LspAttach",
		},
		{
			'numToStr/Comment.nvim',
			event = "BufRead",
		},
		'lewis6991/gitsigns.nvim',
		{ 'sindrets/diffview.nvim' },
		{
			'nvim-treesitter/nvim-treesitter',
			-- tag = "v0.9.0",
			build = ':TSUpdate',
		},
		'lukas-reineke/indent-blankline.nvim',
		{
			'neovim/nvim-lspconfig',
			event = "BufRead",
		},
		{
			'hrsh7th/nvim-cmp',
			event = "BufRead",
		},
		{
			'hrsh7th/cmp-nvim-lsp',
			event = "BufRead",
		},
		{
			'hrsh7th/cmp-path',
			event = "BufRead",
		},
		{
			'hrsh7th/cmp-nvim-lsp-signature-help',
			event = "BufRead",
		},
		{
			'L3MON4D3/LuaSnip',
			event = "BufRead",
			config = function() require('lazyConfigs/luasnip') end,
		},
		{
			'saadparwaiz1/cmp_luasnip',
			event = "BufRead",
		},
		{
			'kyazdani42/nvim-tree.lua',
			dependencies = {
				'kyazdani42/nvim-web-devicons',
			},
			event = "VimEnter",
			config = function() require('lazyConfigs/nvimtree') end,
		},

		{
			'folke/trouble.nvim',
			event = "BufRead",
		},
		-- 'arcticicestudio/nord-vim',
		{
			'CosmicSyntax/nord',
			branch = 'nvim10',
		},
		-- 'gbprod/nord.nvim',
		'karb94/neoscroll.nvim',
		'anuvyklack/windows.nvim',
		'anuvyklack/middleclass',
		-- pictograms
		{
			'onsails/lspkind-nvim',
			event = "BufRead",
		},
		'nvim-telescope/telescope.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		'nvim-telescope/telescope-ui-select.nvim',
		'nvim-lua/plenary.nvim',
		-- 'kdheepak/lazygit.nvim',
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim", -- required
				"sindrets/diffview.nvim", -- optional - Diff integration

				-- Only one of these is needed.
				"nvim-telescope/telescope.nvim", -- optional
			},
			config = true
		},
		{
			'ruifm/gitlinker.nvim',
			event = "BufRead",
			config = function() require('lazyConfigs/tools') end,
		},
		{
			"folke/flash.nvim",
			event = "BufRead",
			config = function()
				require('lazyConfigs/flash')
			end,
		},
		-- lazy.nvim
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			opts = {
				views = {
					cmdline_popup = {
						position = {
							row = "50%",
							col = "50%",
						},
						size = {
							width = 75,
							height = "auto",
						},
					},
				},
				lsp = {
					progress = {
						enabled = false,
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
			},
			dependencies = {
				"MunifTanjim/nui.nvim",
			}
		},
		'github/copilot.vim',
		{
			'sebdah/vim-delve',
			ft = { 'go' },
			config = function()
				require('lazyConfigs/go')
				require('lazyConfigs/inlay')
			end,
		},
		{
			'buoto/gotests-vim',
			ft = { 'go' },
		},
		-- Internal
		{
			dir = '~/.config/nvim/lua/lazyConfigs/ts.lua',
			ft = { 'typescript', 'javascript', 'html' },
			config = function()
				require('lazyConfigs/ts')
				require('lazyConfigs/inlay')
			end,
		},
		{
			dir = '~/.config/nvim/lua/lazyConfigs/rust.lua',
			ft = { 'rust' },
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
			ft = { 'python' },
			config = function() require('lazyConfigs/python') end,
		},
		{
			dir = '~/.config/nvim/lua/lazyConfigs/bash.lua',
			ft = { 'sh' },
			config = function()
				require('lazyConfigs/bash')
				require('lazyConfigs/inlay')
			end,
		},
		{
			dir = '~/.config/nvim/lua/lazyConfigs/c.lua',
			ft = { 'c', 'cpp' },
			config = function()
				require('lazyConfigs/c')
				require('lazyConfigs/inlay')
			end,
		},
		{
			dir = '~/.config/nvim/lua/lazyConfigs/sql.lua',
			ft = { 'sql' },
			config = function() require('lazyConfigs/sql') end,
		},
		{
			dir = '~/.config/nvim/lua/lazyConfigs/lua.lua',
			ft = { 'lua' },
			config = function()
				require('lazyConfigs/lua')
				require('lazyConfigs/inlay')
			end,
		},
		{
			dir = '~/.config/nvim/lua/lazyConfigs/vue.lua',
			ft = { 'vue' },
			config = function()
				require('lazyConfigs/vue')
			end,
		},
		{
			dir = '~/.config/nvim/lua/lazyConfigs/zig.lua',
			ft = { 'zig' },
			config = function()
				require('lazyConfigs/zig')
				require('lazyConfigs/inlay')
			end,
		},
		{
			dir = '~/.config/nvim/lua/lazyConfigs/tf.lua',
			ft = { 'terraform', 'terraform-vars' },
			config = function()
				require('lazyConfigs/tf')
			end,
		},
		{
			dir = '~/.config/nvim/lua/lazyConfigs/docker.lua',
			ft = { 'dockerfile' },
			config = function()
				require('lazyConfigs/docker')
			end,
		},
		{
			'puremourning/vimspector',
			ft = { 'rust', 'c', 'cpp', 'python' },
		} -- Ensure you have python3 imported
	},
	{
		ui = {
			backdrop = 100,
		}
	})
