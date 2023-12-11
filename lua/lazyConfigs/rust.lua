-- nvim_lsp object
local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup{
	capabilities = capabilities,
	filetypes = { "rust" },
	cmd = {"rust-analyzer"},
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true
			},
			-- inlayHints = {
			-- 	implicitDrops = {
			-- 		enable = true,
			-- 	},
			-- },
			checkOnSave = {
				command = "clippy",
			}
		}
	}
}

-- Rust Proc Macro Expand
vim.cmd(
	"command! RustExpandMacro :lua require('lazyConfigs/rustUtils/utils').expand_macro()"
)
