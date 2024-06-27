local nvim_lsp = require 'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Typescript
nvim_lsp.tsserver.setup({
	capabilities = capabilities,
	init_options = {
		preferences = {
			includeInlayParameterNameHints = 'all',
			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
			importModuleSpecifierPreference = 'non-relative',
		},
	},
})

nvim_lsp.html.setup({
	capabilities = capabilities,
})
