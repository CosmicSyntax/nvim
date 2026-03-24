local capabilities = require('lazyConfigs.shared')

-- Enable kulala-ls
vim.lsp.config["kulala_ls"] = {
	capabilities = capabilities,
	cmd = { "kulala-ls", "--stdio" },
	filetypes = { "http" },
}
vim.lsp.enable("kulala_ls")

require("kulala").setup({
	global_keymaps = false,
	icons = {
		textHighlight = "Normal"
	}
})
