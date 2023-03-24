local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Gopls
nvim_lsp.gopls.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		require("lsp-inlayhints").on_attach(client, bufnr)
	end,
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
