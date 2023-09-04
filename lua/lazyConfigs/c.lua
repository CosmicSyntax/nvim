local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable ClangD
nvim_lsp.clangd.setup({
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--background-index",
		"--suggest-missing-includes",
		'--query-driver="/usr/local/opt/gcc-arm-none-eabi-8-2019-q3-update/bin/arm-none-eabi-gcc"'
		},
	filetypes = {"c", "cpp", "objc", "objcpp"},
})
vim.api.nvim_exec_autocmds("FileType", {})
