local nvim_lsp = require 'lspconfig'
local cmp = require('blink.cmp')
local capabilities = cmp.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Vue language server
nvim_lsp.volar.setup({
	capabilities = capabilities,
	filetypes = { "vue" },
})
