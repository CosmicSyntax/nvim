-- nvim_lsp object
local nvim_lsp = require 'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup {
	capabilities = capabilities,
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
			}
		}
	}
}

-- TEMP FIX for server cancellation error pop-up in neovim
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
	local default_diagnostic_handler = vim.lsp.handlers[method]
	vim.lsp.handlers[method] = function(err, result, context, config)
		if err ~= nil and err.code == -32802 then
			return
		end
		return default_diagnostic_handler(err, result, context, config)
	end
end

-- Rust Proc Macro Expand
vim.cmd(
	[[
		command! RustExpandMacro :lua require('lazyConfigs/rustUtils/macro')()
		command! RustViewHIR :lua require('lazyConfigs/rustUtils/hir')()
		command! RustViewMIR :lua require('lazyConfigs/rustUtils/mir')()
	]]
)
