local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable MS Pyright
vim.lsp.config["pyright"] = {
	capabilities = capabilities,
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
}
vim.lsp.enable("pyright")

-- Enabled PyLsp
vim.lsp.config["pylsp"] = {
	capabilities = capabilities,
	cmd = { "pylsp" },
	filetypes = { "python" },
}
vim.lsp.enable("pylsp")
