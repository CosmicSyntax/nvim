local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Typescript
nvim_lsp.tsserver.setup({
	capabilities = capabilities,
})
vim.api.nvim_exec_autocmds("FileType", {})
vim.lsp.inlay_hint(0, true)
