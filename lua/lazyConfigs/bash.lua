local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Bash-LSP
nvim_lsp.bashls.setup({
	capabilities = capabilities,
	filetypes = { "sh" },
	cmd = {'bash-language-server', 'start'},
})
