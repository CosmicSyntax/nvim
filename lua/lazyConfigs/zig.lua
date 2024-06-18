local nvim_lsp = require 'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Gopls
nvim_lsp.zls.setup({
	capabilities = capabilities,
	filetypes = { "zig", "zir" },
	cmd = { 'zls' },
})
