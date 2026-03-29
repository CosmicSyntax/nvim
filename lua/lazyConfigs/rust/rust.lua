-- 1. Fetch Capabilities
local capabilities = require('lazyConfigs.shared')
capabilities.experimental = {
	serverStatusNotification = true,
}

-- 2. Configure the Server
vim.lsp.config['rust-analyzer'] = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = { group = "module" },
				prefix = "self",
			},
			cargo = {
				buildScripts = { enable = true },
				-- features = { "full" },
			},
			procMacro = { enable = true },
			inlayHints = {
				enable = true,
				showParameterNames = true,
			},
			checkOnSave = { command = "clippy" },
			hover = {
				memoryLayout = { niches = true },
			},
		}
	},
}

-- 3. Enable the Server
vim.lsp.enable('rust-analyzer')

-- 4. Native Lua Custom Commands (Replacing vim.cmd)
local create_cmd = vim.api.nvim_create_user_command

create_cmd('RustExpandMacro', function()
	require('lazyConfigs.rustUtils.macro')()
end, { desc = "Expand Rust Macro under cursor" })

create_cmd('RustViewHIR', function()
	require('lazyConfigs.rustUtils.hir')()
end, { desc = "View Rust HIR" })

create_cmd('RustViewMIR', function()
	require('lazyConfigs.rustUtils.mir')()
end, { desc = "View Rust MIR" })
