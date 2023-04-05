local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable MS Pyright
nvim_lsp.pyright.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		require("lsp-inlayhints").on_attach(client, bufnr)
	end,
})

-- Null ls config for pylint
local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.pylint.with({
			diagnostic_config = { underline = false, virtual_text = false, signs = false },
			method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
		}),
	},
})
