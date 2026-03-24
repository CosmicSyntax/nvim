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
	'https://github.com/nvim-treesitter/nvim-treesitter',

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
-- vim.pack does not execute plugin setups automatically, so we do it here:
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

-- 4. Filetype Specific Configurations (Replacing 'ft' lazy-loading)
-- We use native autocommands to load your local internal configs only when needed.

local lazy_group = vim.api.nvim_create_augroup('LazyConfigs', { clear = true })

local function on_filetype(patterns, callback)
	vim.api.nvim_create_autocmd('FileType', {
		group = lazy_group,
		pattern = patterns,
		callback = callback
	})
end

on_filetype({ 'typescript', 'typescriptreact', 'javascript', 'html', 'htmldjango' }, function()
	require('lazyConfigs.ts.ts')
	require('lazyConfigs.inlay')
end)

on_filetype({ 'rust' }, function()
	require('lazyConfigs.rust.rust')
	require('lazyConfigs.inlay')
end)

on_filetype({ 'go' }, function()
	require('lazyConfigs.go.go')
	require('lazyConfigs.inlay')
end)

on_filetype({ 'python' }, function()
	require('lazyConfigs.python.python')
end)

on_filetype({ 'sh' }, function()
	require('lazyConfigs.bash.bash')
	require('lazyConfigs.inlay')
end)

on_filetype({ 'c', 'cpp' }, function()
	require('lazyConfigs.c.c')
	require('lazyConfigs.inlay')
end)

on_filetype({ 'sql' }, function() require('lazyConfigs.sql.sql') end)
on_filetype({ 'vue' }, function() require('lazyConfigs.vue.vue') end)
on_filetype({ 'terraform', 'terraform-vars' }, function() require('lazyConfigs.tf.tf') end)
on_filetype({ 'dockerfile' }, function() require('lazyConfigs.docker.docker') end)

on_filetype({ 'lua' }, function()
	require('lazyConfigs.lua.lua')
	require('lazyConfigs.inlay')
end)

on_filetype({ 'zig' }, function()
	require('lazyConfigs.zig.zig')
	require('lazyConfigs.inlay')
end)

on_filetype(
{ 'html', 'htmldjango', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue' },
	function()
		require('lazyConfigs.tailwind.tailwind')
		require('lazyConfigs.inlay')
	end)

-- Tool specific lazy loads
on_filetype({ 'toml' }, function()
	if vim.fn.expand('%:t') == 'Cargo.toml' then
		require('crates').setup()
	end
end)

on_filetype({ 'http', 'rest' }, function()
	require('lazyConfigs.kulala.kulala')
	require('lazyConfigs.inlay')
end)
