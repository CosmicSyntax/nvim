local capabilities = require('lazyConfigs.shared')

vim.lsp.config["dockerls"] = {
	capabilities = capabilities,
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "Dockerfile", "dockerfile" },
}
vim.lsp.enable("dockerls")
