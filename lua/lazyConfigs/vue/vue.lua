local capabilities = require('lazyConfigs.shared')

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
