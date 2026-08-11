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
			-- Prevents rust-analyzer from locking your main target/ directory
			-- and fighting with your command-line terminal builds.
			cargo = {
				buildScripts = { enable = true },
				features = { "full" },
			},
			procMacro = { enable = true },
			-- Disable initial workspace-wide cache building on startup
			cachePriming = { enable = false },
			-- Keep clippy but ignore external dependency warnings to save time
			checkOnSave = {
				command = "clippy",
				extraArgs = { "--no-deps" },
			},
			imports = {
				granularity = { group = "module" },
				prefix = "self",
			},
			-- Turn off intrusive inlay hints that recompute on every keystroke
			inlayHints = {
				enable = true,
				bindingModeHints = { enable = false },
				chainingHints = { enable = false },
				closingBraceHints = { enable = false },
				parameterHints = { enable = false },
				typeHints = { enable = true },
			},
			hover = {
				memoryLayout = { niches = true },
			},
			workspace = {
				discoverConfiguredRoles = false,
			}
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
