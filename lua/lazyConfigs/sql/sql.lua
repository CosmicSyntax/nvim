local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable SQL-LSP
vim.lsp.config["sqlls"] = {
	capabilities = capabilities,
	cmd = { "sql-language-server", "up", "--method", "stdio" },
	filetypes = { "sql", "mysql" },
}
vim.lsp.enable("sqlls")
