local nvim_lsp = require'lspconfig'
local cmp = require('blink.cmp')
local capabilities = cmp.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable SQL-LSP
nvim_lsp.sqlls.setup({
	capabilities = capabilities,
	filetypes = { "sql", "mysql" },
	cmd = { "sql-language-server", "up", "--method", "stdio" },
})
