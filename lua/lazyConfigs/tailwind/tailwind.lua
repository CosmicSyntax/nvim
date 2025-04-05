local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable TailwindCSS-LSP
vim.lsp.config["tailwindcss"] = {
	capabilities = capabilities,
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = { "html", "htmldjango", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
}
vim.lsp.enable('tailwindcss')
