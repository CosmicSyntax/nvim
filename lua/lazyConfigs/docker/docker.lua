local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.lsp.config["dockerls"] = {
	capabilities = capabilities,
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "Dockerfile", "dockerfile" },
}
vim.lsp.enable("dockerls")
