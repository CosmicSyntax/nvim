local capabilities = require('lazyConfigs.shared')

-- Enable SQL-LSP
vim.lsp.config["sqlls"] = {
	capabilities = capabilities,
	cmd = { "sql-language-server", "up", "--method", "stdio" },
	filetypes = { "sql", "mysql" },
}
vim.lsp.enable("sqlls")
