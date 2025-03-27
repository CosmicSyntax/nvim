local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Gopls
vim.lsp.config["gopls"] = {
	capabilities = capabilities,
	cmd = {'gopls', '--remote=auto'},
	filetypes = { "go", "gomod" },
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
}
vim.lsp.enable("gopls")
