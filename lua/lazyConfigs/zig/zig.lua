local nvim_lsp = require 'lspconfig'
local cmp = require('blink.cmp')
local capabilities = cmp.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Gopls
nvim_lsp.zls.setup({
	capabilities = capabilities,
	filetypes = { "zig", "zir" },
	cmd = { 'zls' },
})
