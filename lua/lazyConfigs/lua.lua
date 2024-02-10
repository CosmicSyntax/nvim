local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable Gopls
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
