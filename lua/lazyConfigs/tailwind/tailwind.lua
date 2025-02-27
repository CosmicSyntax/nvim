local nvim_lsp = require'lspconfig'
local cmp = require('blink.cmp')
local capabilities = cmp.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

nvim_lsp.tailwindcss.setup({
	capabilities = capabilities,
})
