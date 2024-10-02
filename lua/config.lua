-- Treesitter
require 'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"rust",
		"go",
		"python",
		"bash",
		"typescript",
		"cpp",
		"sql",
		"html",
		"markdown",
		"markdown_inline",
		"terraform",
		"vimdoc",
		"regex",
		"toml",
		"yaml",
	},
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	autopairs = {
		enable = true,
	},
}

-- Nvim Telescope
require("telescope").setup {
	defaults = {
		vimgrep_arguments = {
			'rg',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case',
			'--glob',
			'!**/Cargo.lock',
			-- '-.'
		},
	},
	pickers = {
		find_files = {
			-- theme = "dropdown",
			-- hidden = true,
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown {}
		}
	}
}
require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")

-- Nord... because there is nothing better
-- require('nord').setup({
-- 	styles = {
-- 		comments = { italic = true },
-- 		keywords = {},
-- 		functions = { bold = true },
-- 		variables = {},
-- 		bufferline = {
-- 			current = {},
-- 			modified = { italic = true },
-- 		},
-- 	}
-- })
vim.cmd("colorscheme nord")
vim.cmd([[highlight Comment cterm=italic gui=italic]])
vim.cmd([[highlight Function cterm=bold gui=bold]])
vim.api.nvim_set_hl(0, 'LineNr', { fg = "#ebcb8b" })
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = "#4c566a" })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = "#4c566a" })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = "#4c566a" })
vim.api.nvim_set_hl(0, 'NeogitDiffAddHighlight', { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, 'NeogitDiffDeleteHighlight', { link = 'DiffDelete' })
vim.api.nvim_set_hl(0, 'NeogitDiffAdd', { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, 'NeogitDiffDelete', { link = 'DiffDelete' })

-- Line Setup
-- require('lualine').setup {
-- 	options = {
-- 		icons_enabled = true,
-- 		theme = 'onenord',
-- 		section_separators = { left = '', right = '' },
-- 		component_separators = { left = '', right = '' },
-- 		disabled_filetypes = {},
-- 		always_divide_middle = true,
-- 		globalstatus = true,
-- 	};
-- 	sections = {
-- 		lualine_a = {'mode'},
-- 		lualine_b = {
-- 			'branch',
-- 			{
-- 				'filename',
-- 				file_status = true,
-- 				path = 1,
-- 			},
-- 			'diff',
-- 		},
-- 		lualine_c = {'diagnostics', 'lsp_progress'},
-- 		lualine_x = {'encoding', 'fileformat', 'filetype'},
-- 		lualine_y = {'progress'},
-- 		lualine_z = {'location'},
-- 	};
-- 	inactive_sections = {
-- 		lualine_a = {},
-- 		lualine_b = {},
-- 		lualine_c = {'filename'},
-- 		lualine_x = {'location'},
-- 		lualine_y = {},
-- 		lualine_z = {}
-- 	};
-- 	tabline = {},
-- 	extensions = {'nvim-tree', 'quickfix'},
-- }
-- vim.o.laststatus = 3

-- stop nvim_lsp auto jump for GI
local log = require 'vim.lsp.log'
local util = require 'vim.lsp.util'
local jump_handle = function(_, result, ctx, _)
	if result == nil or vim.tbl_isempty(result) then
		local _ = log.info() and log.info(ctx.method, 'No location found')
		return nil
	end
	local client = vim.lsp.get_client_by_id(ctx.client_id)

	if vim.islist(result) then
		if #result > 1 then
			vim.fn.setqflist({}, ' ', {
				title = 'LSP locations',
				items = util.locations_to_items(result, client.offset_encoding)
			})
			-- vim.api.nvim_command("botright copen")
			require("trouble").toggle("quickfix")
		else
			util.jump_to_location(result[1], client.offset_encoding)
		end
	else
		util.jump_to_location(result, client.offset_encoding)
	end
end
vim.lsp.handlers["textDocument/implementation"] = jump_handle
vim.lsp.handlers["textDocument/definition"] = jump_handle
vim.lsp.handlers["textDocument/typeDefinition"] = jump_handle
vim.lsp.handlers["textDocument/references"] = jump_handle

-- -- nvim_lsp object
-- local nvim_lsp = require'lspconfig'
-- local cmp = require('cmp_nvim_lsp')
-- local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- capabilities = cmp.update_capabilities(lsp_status.capabilities)

-- Enable Solargraph
-- nvim_lsp.solargraph.setup({
-- 	capabilities = capabilities,
-- 	flags = {
-- 		debounce_text_changes = 150,
-- 	},
-- })

-- Enable R LSP
-- nvim_lsp.r_language_server.setup{
-- 	capabilities = capabilities,
-- }

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = true,
		signs = true,
		update_in_insert = true,
	}
)
