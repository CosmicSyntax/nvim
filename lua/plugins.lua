-- 1. Build Hooks
-- vim.pack handles hooks via the 'PackChanged' autocommand prior to adding plugins
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind

		-- Run on both fresh installs and updates
		if kind == 'install' or kind == 'update' then
			-- Treesitter Hook
			if name == 'nvim-treesitter' then
				if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
				vim.cmd('TSUpdate')

				-- Telescope FZF Native Hook
			elseif name == 'telescope-fzf-native.nvim' then
				-- Dynamically get the plugin directory path
				local plugin_dir = vim.fn.stdpath('data') .. '/site/pack/core/opt/telescope-fzf-native.nvim'

				-- Silently run `make` in that directory
				vim.fn.system({ 'make', '-C', plugin_dir })

				-- Let you know it finished successfully
				vim.notify("Compiled telescope-fzf-native.nvim!", vim.log.levels.INFO)
			end
		end
	end
})

-- 2. Install and Load Plugins
vim.pack.add({
	-- Core & Editing
	'https://github.com/windwp/nvim-autopairs',
	'https://github.com/numToStr/Comment.nvim',
	'https://github.com/lukas-reineke/indent-blankline.nvim',
	'https://github.com/karb94/neoscroll.nvim',
	'https://github.com/anuvyklack/middleclass', -- dependency for windows.nvim
	'https://github.com/anuvyklack/windows.nvim',

	-- LSP & Completion
	'https://github.com/j-hui/fidget.nvim',
	'https://github.com/onsails/lspkind-nvim',
	'https://github.com/rafamadriz/friendly-snippets', -- dependency for blink.cmp
	{ src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },
	'https://github.com/zbirenbaum/copilot.lua',

	-- Syntax & Treesitter
	{
		src = 'https://github.com/nvim-treesitter/nvim-treesitter',
		branch = 'main',
	},

	-- UI & Navigation
	'https://github.com/kyazdani42/nvim-web-devicons', -- dependency for nvim-tree
	'https://github.com/kyazdani42/nvim-tree.lua',
	'https://github.com/folke/trouble.nvim',
	'https://github.com/gbprod/nord.nvim',
	'https://github.com/folke/flash.nvim',
	'https://github.com/lewis6991/satellite.nvim',

	-- Telescope
	'https://github.com/nvim-lua/plenary.nvim', -- dependency
	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
	'https://github.com/nvim-telescope/telescope-ui-select.nvim',

	-- Git Tools
	'https://github.com/lewis6991/gitsigns.nvim',
	'https://github.com/sindrets/diffview.nvim',
	'https://github.com/NeogitOrg/neogit',
	'https://github.com/ruifm/gitlinker.nvim',

	-- Tooling & Debugging
	'https://github.com/saecki/crates.nvim',
	'https://github.com/puremourning/vimspector',
	'https://github.com/buoto/gotests-vim',
	'https://github.com/mistweaverco/kulala.nvim',
})

-- 3. Setup Configurations
vim.cmd.colorscheme('nord')

require('nvim-tree').setup({
	view = { width = 40 },
	filters = { dotfiles = false },
})

require('copilot').setup({})
require('neogit').setup()
require('satellite').setup()

-- Your external tool setups
require('lazyConfigs.flash')
require('lazyConfigs.tools')

-- ==========================================
-- 4. Filetype Specific Configurations
-- ==========================================
-- A data-driven approach to lazy loading. This replaces 45+ lines of
-- repetitive function calls with a single, clean routing table.
local lazy_loads = {
	[{ 'typescript', 'typescriptreact', 'javascript', 'html', 'htmldjango' }]                                                    = { 'lazyConfigs.ts.ts', 'lazyConfigs.inlay' },
	[{ 'rust' }]                                                                                                                 = { 'lazyConfigs.rust.rust', 'lazyConfigs.inlay' },
	[{ 'go' }]                                                                                                                   = { 'lazyConfigs.go.go', 'lazyConfigs.inlay' },
	[{ 'python' }]                                                                                                               = { 'lazyConfigs.python.python' },
	[{ 'sh' }]                                                                                                                   = { 'lazyConfigs.bash.bash', 'lazyConfigs.inlay' },
	[{ 'c', 'cpp' }]                                                                                                             = { 'lazyConfigs.c.c', 'lazyConfigs.inlay' },
	[{ 'sql' }]                                                                                                                  = { 'lazyConfigs.sql.sql' },
	[{ 'vue' }]                                                                                                                  = { 'lazyConfigs.vue.vue' },
	[{ 'terraform', 'terraform-vars' }]                                                                                          = { 'lazyConfigs.tf.tf' },
	[{ 'dockerfile' }]                                                                                                           = { 'lazyConfigs.docker.docker' },
	[{ 'lua' }]                                                                                                                  = { 'lazyConfigs.lua.lua', 'lazyConfigs.inlay' },
	[{ 'zig' }]                                                                                                                  = { 'lazyConfigs.zig.zig', 'lazyConfigs.inlay' },
	[{ 'http', 'rest' }]                                                                                                         = { 'lazyConfigs.kulala.kulala', 'lazyConfigs.inlay' },
	-- Tailwind covers multiple overlapping types
	[{ 'html', 'htmldjango', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue' }] = { 'lazyConfigs.tailwind.tailwind', 'lazyConfigs.inlay' },
}

local lazy_group = vim.api.nvim_create_augroup('LazyConfigs', { clear = true })

for patterns, modules in pairs(lazy_loads) do
	vim.api.nvim_create_autocmd('FileType', {
		group = lazy_group,
		pattern = patterns,
		callback = function()
			for _, mod in ipairs(modules) do
				-- Using pcall (protected call) prevents one failing config
				-- (like a typo in a lua file) from breaking the whole chain
				local ok, err = pcall(require, mod)
				if not ok then
					vim.notify("Failed to load: " .. mod .. "\n" .. err, vim.log.levels.ERROR)
				end
			end
		end
	})
end

-- Tool specific lazy loads that require extra conditional logic
vim.api.nvim_create_autocmd('FileType', {
	group = lazy_group,
	pattern = 'toml',
	callback = function()
		if vim.fn.expand('%:t') == 'Cargo.toml' then
			require('crates').setup()
		end
	end
})
