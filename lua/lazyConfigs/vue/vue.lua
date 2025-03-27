local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Vue language server
vim.lsp.config["volar"] = {
	capabilities = capabilities,
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	init_options = {
		typescript = {
			tsdk = ""
		}
	}
}
vim.lsp.enable("volar")
