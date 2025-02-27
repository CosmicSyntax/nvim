local nvim_lsp = require 'lspconfig'
local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Lua language server
nvim_lsp.lua_ls.setup({
	capabilities = capabilities,
	filetypes = { "lua" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			},
			hint = {
				enable = true,
			},
		},
	},
})
