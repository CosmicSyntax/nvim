local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable ZLS
vim.lsp.config["zls"] = {
	capabilities = capabilities,
	cmd = { 'zls' },
	filetypes = { "zig", "zir" },
}
vim.lsp.enable("zls")
