local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

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
