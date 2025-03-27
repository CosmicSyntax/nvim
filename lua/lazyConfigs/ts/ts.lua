local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable TypeScript-LSP
vim.lsp.config["tsserver"] = {
	capabilities = capabilities,
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	init_options = {
		preferences = {
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			includeInlayVariableTypeHints = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
	},
}

-- Enable HTML-LSP
vim.lsp.config["html"] = {
	capabilities = capabilities,
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
}
