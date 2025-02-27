local nvim_lsp = require 'lspconfig'
local cmp = require('blink.cmp')
local capabilities = cmp.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Typescript
-- nvim_lsp.tsserver.setup({
-- 	capabilities = capabilities,
-- 	init_options = {
-- 		preferences = {
-- 			includeInlayParameterNameHints = 'all',
-- 			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
-- 			includeInlayFunctionParameterTypeHints = true,
-- 			includeInlayVariableTypeHints = true,
-- 			includeInlayPropertyDeclarationTypeHints = true,
-- 			includeInlayFunctionLikeReturnTypeHints = true,
-- 			includeInlayEnumMemberValueHints = true,
-- 			importModuleSpecifierPreference = 'non-relative',
-- 		},
-- 	},
-- })
nvim_lsp.ts_ls.setup({
	capabilities = capabilities,
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
})

nvim_lsp.html.setup({
	capabilities = capabilities,
})
