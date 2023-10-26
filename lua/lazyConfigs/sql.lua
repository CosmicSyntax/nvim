local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable SQL-LSP
nvim_lsp.sqlls.setup({
	capabilities = capabilities,
	filetypes = { "sql", "mysql" },
	cmd = { "sql-language-server", "up", "--method", "stdio" },
})
