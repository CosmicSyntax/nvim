local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Gopls
nvim_lsp.pyright.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		require("lsp-inlayhints").on_attach(client, bufnr)
	end,
})
