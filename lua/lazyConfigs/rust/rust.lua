local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.experimental = {
	serverStatusNotification = true,
}

-- Enable rust_analyzer
vim.lsp.config['rust-analyzer'] = {
	filetypes = { "rust" },
	cmd = { "rust-analyzer" },
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
				-- extraEnv = {
				-- 	["RUSTFLAGS"] = "--cfg loom",
				-- },
				features = {
					"full",
				},
			},
			procMacro = {
				enable = true
			},
			inlayHints = {
				-- implicitDrops = {
				-- 	enable = true,
				-- },
				enable = true,
				showParameterNames = true,
				-- parameterHintsPrefix = "<- ",
				-- otherHintsPrefix = "=> ",
			},
			checkOnSave = {
				command = "clippy",
			},
			hover = {
				memoryLayout = {
					niches = true,
				},
			},
		}
	},
	capabilities = capabilities,
}
vim.lsp.enable('rust-analyzer')

-- Rust Proc Macro Expand
vim.cmd(
	[[
		command! RustExpandMacro :lua require('lazyConfigs/rustUtils/macro')()
		command! RustViewHIR :lua require('lazyConfigs/rustUtils/hir')()
		command! RustViewMIR :lua require('lazyConfigs/rustUtils/mir')()
	]]
)
