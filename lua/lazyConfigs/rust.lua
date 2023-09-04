-- nvim_lsp object
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable rust_analyzer
local rt = require('rust-tools')
local opts = {
	tools = {
		auto = false,
		on_initialized = nil,

		-- These apply to the default RustSetInlayHints command
		inlay_hints = {
			auto = false,
			-- only_current_line = false,
			-- show_parameter_hints = true,
			-- parameter_hints_prefix = "",
			-- other_hints_prefix = "-> ",
			-- max_len_align = false,
			-- max_len_align_padding = 1,
			-- right_align = false,
			-- right_align_padding = 7,
			-- highlight = "BufferLineDiagnosticVisible",
		},
		hover_actions = {
			border = {
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{" ", "FloatBorder"},
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{" ", "FloatBorder"},
			},
			auto_focus = false,
		},
	},
	server = {
		capabilities = capabilities,
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
		end,
		settings = {
			["rust-analyzer"] = {
				assist = {
					importGranularity = "module",
					importPrefix = "by_self",
				},
				cargo = {
					loadOutDirsFromCheck = true,
				},
				procMacro = {
					enable = true,
					attributes = {
						enabled = true,
					}
				},
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}
rt.setup(opts)
vim.api.nvim_exec_autocmds("FileType", {})
