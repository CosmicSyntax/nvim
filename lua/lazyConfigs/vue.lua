local nvim_lsp = require 'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Vue language server
nvim_lsp.volar.setup({
	capabilities = capabilities,
	filetypes = { "vue" },
})
