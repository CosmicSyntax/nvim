-- nvim_lsp object
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- capabilities = cmp.update_capabilities(lsp_status.capabilities)
local mason_registry = require("mason-registry")
local codelldb = mason_registry.get_package("codelldb")
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

-- Enable rust_analyzer
local rt = require('rust-tools')
local opts = {
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
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
		on_attach = function(client, bufnr)
			require("lsp-inlayhints").on_attach(client, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			-- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
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
