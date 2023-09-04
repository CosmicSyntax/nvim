local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Gopls
nvim_lsp.gopls.setup({
	capabilities = capabilities,
	filetypes = { "go", "gomod" },
	cmd = {'gopls', '--remote=auto'},
	settings = {
		analyses = {
			unusedparams = true,
		},
		staticcheck = true,
		gopls = {
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})
vim.api.nvim_exec_autocmds("FileType", {})
