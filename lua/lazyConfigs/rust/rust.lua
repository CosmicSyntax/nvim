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
				-- features = {
				-- 	"notebook",
				-- 	"lifecycle",
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
vim.lsp.enable('rust-analyzer')

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
