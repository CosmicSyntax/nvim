local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')

-- Enable SQL-LSP
nvim_lsp.sqlls.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		require("lsp-inlayhints").on_attach(client, bufnr)
	end,
	filetypes = { "sql", "mysql" },
	cmd = { "sql-language-server", "up", "--method", "stdio" },
})
