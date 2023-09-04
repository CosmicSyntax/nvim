local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')

-- Enable SQL-LSP
nvim_lsp.sqlls.setup({
	capabilities = capabilities,
	filetypes = { "sql", "mysql" },
	cmd = { "sql-language-server", "up", "--method", "stdio" },
})
vim.api.nvim_exec_autocmds("FileType", {})
