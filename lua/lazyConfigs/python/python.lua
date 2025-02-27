local nvim_lsp = require'lspconfig'
local cmp = require('blink.cmp')
local capabilities = cmp.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable MS Pyright
nvim_lsp.pyright.setup({
	capabilities = capabilities,
})
-- Enabled PyLsp
nvim_lsp.pylsp.setup({
	capabilities = capabilities,
})
