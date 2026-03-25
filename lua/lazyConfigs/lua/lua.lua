local capabilities = require('lazyConfigs.shared')

-- Enable Lua language server
vim.lsp.config["lua_ls"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }
			},
			hint = {
				enable = true,
			},
		},
	},
	capabilities = capabilities,
}
vim.lsp.enable("lua_ls")
