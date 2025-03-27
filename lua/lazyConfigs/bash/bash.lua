local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Bash-LSP
vim.lsp.config["bashls"] = {
	capabilities = capabilities,
	filetypes = { "sh" },
	cmd = { 'bash-language-server', 'start' },
}
vim.lsp.enable("bashls")
