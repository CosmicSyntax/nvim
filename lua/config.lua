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
local validate = vim.validate
local api = vim.api
local lsp = vim.lsp
local util = require('vim.lsp.util')
local ms = require('vim.lsp.protocol').Methods
---@param context (table|nil) Context for the request
---@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_references
---@param opts? vim.lsp.ListOpts
local function references(context, opts)
	validate('context', context, 'table', true)
	local bufnr = api.nvim_get_current_buf()
	local clients = lsp.get_clients({ method = ms.textDocument_references, bufnr = bufnr })
	if not next(clients) then
		return
	end
	local win = api.nvim_get_current_win()
	opts = opts or {}

	local all_items = {}
	local title = 'References'

	local function on_done()
		if not next(all_items) then
			vim.notify('No references found')
		else
			local list = {
				title = title,
				items = all_items,
				context = {
					method = ms.textDocument_references,
					bufnr = bufnr,
				},
			}
			if opts.loclist then
				vim.fn.setloclist(0, {}, ' ', list)
				require("trouble").toggle("quickfix")
			elseif opts.on_list then
				assert(vim.is_callable(opts.on_list), 'on_list is not a function')
				opts.on_list(list)
			else
				vim.fn.setqflist({}, ' ', list)
				require("trouble").toggle("quickfix")
			end
		end
	end

	local remaining = #clients
	for _, client in ipairs(clients) do
		local params = util.make_position_params(win, client.offset_encoding)

		---@diagnostic disable-next-line: inject-field
		params.context = context or {
			includeDeclaration = true,
		}
		client.request(ms.textDocument_references, params, function(_, result)
			local items = util.locations_to_items(result or {}, client.offset_encoding)
			vim.list_extend(all_items, items)
			remaining = remaining - 1
			if remaining == 0 then
				on_done()
			end
		end)
	end
end
vim.lsp.buf.references = references

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
