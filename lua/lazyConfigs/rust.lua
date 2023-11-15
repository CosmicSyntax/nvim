-- nvim_lsp object
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable rust_analyzer
require'lspconfig'.rust_analyzer.setup{
	capabilities = capabilities,
	filetypes = { "rust" },
	cmd = {"rust-analyzer"},
	settings = {
		['rust-analyzer'] = {
			diagnostics = {
				enable = true;
			}
		}
	}
}
