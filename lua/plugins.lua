-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
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
		{
			'lewis6991/gitsigns.nvim',
			event = "VeryLazy",
		},
		'sindrets/diffview.nvim',
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
			'saghen/blink.cmp',
			dependencies = 'rafamadriz/friendly-snippets',
			version = '*',
			opts = {
				-- TODO: clean this up
				keymap = {
					preset = 'none',
					['<S-K>'] = { 'show', 'show_documentation', 'hide_documentation', "fallback" },
					['<CR>'] = { 'select_and_accept', 'fallback' },

					['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
					['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

					['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
					['<C-j>'] = { 'scroll_documentation_down', 'fallback' },

					['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
					['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
				},
				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = 'mono'
				},
				sources = {
					default = { 'lsp', 'path', 'snippets', 'buffer' },
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
				signature = {
					enabled = true,
					window = {
						winblend = 30,
					},
				},
			},
			opts_extend = { "sources.default" },
			event = "VeryLazy",
		},
		{
			'kyazdani42/nvim-tree.lua',
			dependencies = {
				'kyazdani42/nvim-web-devicons',
			},
			event = "VimEnter",
			opts = {
				view = {
					width = 40,
				},
				filters = {
					dotfiles = false,
				},
			},
		},
		{
			'folke/trouble.nvim',
			event = "BufRead",
		},
		-- 'arcticicestudio/nord-vim',
		-- {
		-- 	'CosmicSyntax/nord',
		-- 	branch = 'nvim10',
		-- },
		{
			'gbprod/nord.nvim',
			lazy = false,
			priority = 1000,
		},
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
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"sindrets/diffview.nvim",
				"nvim-telescope/telescope.nvim", -- optional
			},
			event = "VeryLazy",
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
		'github/copilot.vim',
		{
			'sebdah/vim-delve',
			ft = { 'go' },
			config = function()
				require('lazyConfigs/go/go')
				require('lazyConfigs/inlay')
			end,
		},
		{
			'buoto/gotests-vim',
			ft = { 'go' },
		},
		{
			"lewis6991/satellite.nvim",
			event = "BufRead",
			opts = {},
		},

		-- Internal
		{
			name = "typescript",
			dir = '~/.config/nvim/lua/lazyConfigs/ts',
			ft = { 'typescript', 'typescriptreact', 'javascript', 'html', 'htmldjango' },
			config = function()
				require('lazyConfigs/ts/ts')
				require('lazyConfigs/inlay')
			end,
		},
		{
			name = "rust",
			dir = '~/.config/nvim/lua/lazyConfigs/rust/',
			ft = { 'rust' },
			config = function()
				require('lazyConfigs/rust/rust')
				require('lazyConfigs/inlay')
			end,
		},
		{
			name = "python",
			dir = '~/.config/nvim/lua/lazyConfigs/python',
			ft = { 'python' },
			config = function() require('lazyConfigs/python/python') end,
		},
		{
			name = "bash",
			dir = '~/.config/nvim/lua/lazyConfigs/bash',
			ft = { 'sh' },
			config = function()
				require('lazyConfigs/bash/bash')
				require('lazyConfigs/inlay')
			end,
		},
		{
			name = "c",
			dir = '~/.config/nvim/lua/lazyConfigs/c',
			ft = { 'c', 'cpp' },
			config = function()
				require('lazyConfigs/c/c')
				require('lazyConfigs/inlay')
			end,
		},
		{
			name = "sql",
			dir = '~/.config/nvim/lua/lazyConfigs/sql',
			ft = { 'sql' },
			config = function() require('lazyConfigs/sql/sql') end,
		},
		{
			name = "lua",
			dir = '~/.config/nvim/lua/lazyConfigs/lua',
			ft = { 'lua' },
			config = function()
				require('lazyConfigs/lua/lua')
				require('lazyConfigs/inlay')
			end,
		},
		{
			name = "vue",
			dir = '~/.config/nvim/lua/lazyConfigs/vue',
			ft = { 'vue' },
			config = function()
				require('lazyConfigs/vue/vue')
			end,
		},
		{
			name = "zig",
			dir = '~/.config/nvim/lua/lazyConfigs/zig',
			ft = { 'zig' },
			config = function()
				require('lazyConfigs/zig/zig')
				require('lazyConfigs/inlay')
			end,
		},
		{
			name = "terraform",
			dir = '~/.config/nvim/lua/lazyConfigs/tf/',
			ft = { 'terraform', 'terraform-vars' },
			config = function()
				require('lazyConfigs/tf/tf')
			end,
		},
		{
			name = "docker",
			dir = '~/.config/nvim/lua/lazyConfigs/docker/',
			ft = { 'dockerfile' },
			config = function()
				require('lazyConfigs/docker/docker')
			end,
		},
		{
			name = "tailwindcss",
			dir = '~/.config/nvim/lua/lazyConfigs/tailwind/',
			ft = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html", "htmlangular", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ" },
			config = function()
				require('lazyConfigs/tailwind/tailwind')
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
			'puremourning/vimspector',
			ft = { 'rust', 'c', 'cpp', 'python' },
		} -- Ensure you have python3 imported
	},
	{
		ui = {
			backdrop = 100,
		}
	})
