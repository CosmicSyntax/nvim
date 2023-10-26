local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable MS Pyright
nvim_lsp.pyright.setup({
	capabilities = capabilities,
})

-- Pylint
local lint = require('lint')
lint.linters_by_ft = {
	markdown = {'vale',}
}
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		lint.try_lint()
	end,
})
