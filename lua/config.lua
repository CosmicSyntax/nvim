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
require("nord").setup({
	transparent = false,     -- Enable this to disable setting the background color
	terminal_colors = true,  -- Configure the colors used when opening a `:terminal` in Neovim
	diff = { mode = "bg" },  -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
	borders = true,          -- Enable the border between verticaly split windows visible
	errors = { mode = "bg" }, -- Display mode for errors and diagnostics
	-- values : [bg|fg|none]
	search = { theme = "vim" }, -- theme for highlighting search results
	-- values : [vim|vscode]
	styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = true },
		keywords = {},
		functions = { bold = true },
		variables = {},
	},
})

vim.cmd("colorscheme nord")
-- vim.cmd([[highlight Comment cterm=italic gui=italic]])
-- vim.cmd([[highlight Function cterm=bold gui=bold]])
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

-- Update references to default to Trouble for v0.10.n
local log = require('vim.lsp.log')
local protocol = require('vim.lsp.protocol')
local ms = protocol.Methods
local util = require('vim.lsp.util')
local api = vim.api
--- Jumps to a location. Used as a handler for multiple LSP methods.
---@param _ nil not used
---@param result (table) result of LSP method; a location or a list of locations.
---@param ctx (lsp.HandlerContext) table containing the context of the request, including the method
---@param config? vim.lsp.LocationOpts
---(`textDocument/definition` can return `Location` or `Location[]`
local function location_handler(_, result, ctx, config)
	if result == nil or vim.tbl_isempty(result) then
		log.info(ctx.method, 'No location found')
		return nil
	end
	local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

	config = config or {}

	-- textDocument/definition can return Location or Location[]
	-- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition
	if not vim.islist(result) then
		result = { result }
	end

	local title = 'LSP locations'
	local items = util.locations_to_items(result, client.offset_encoding)

	if config.on_list then
		assert(vim.is_callable(config.on_list), 'on_list is not a function')
		config.on_list({ title = title, items = items })
		return
	end
	if #result == 1 then
		util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
		return
	end
	if config.loclist then
		vim.fn.setloclist(0, {}, ' ', { title = title, items = items })
		require("trouble").toggle("quickfix")
	else
		vim.fn.setqflist({}, ' ', { title = title, items = items })
		require("trouble").toggle("quickfix")
	end
end

vim.lsp.handlers[ms.textDocument_declaration] = location_handler
vim.lsp.handlers[ms.textDocument_definition] = location_handler
vim.lsp.handlers[ms.textDocument_typeDefinition] = location_handler
vim.lsp.handlers[ms.textDocument_implementation] = location_handler
vim.lsp.handlers[ms.textDocument_references] = function(_, result, ctx, config)
	if not result or vim.tbl_isempty(result) then
		vim.notify('No references found')
		return
	end

	local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
	config = config or {}
	local title = 'References'
	local items = util.locations_to_items(result, client.offset_encoding)

	local list = { title = title, items = items, context = ctx }
	if config.loclist then
		vim.fn.setloclist(0, {}, ' ', list)
		require("trouble").toggle("quickfix")
	elseif config.on_list then
		assert(vim.is_callable(config.on_list), 'on_list is not a function')
		config.on_list(list)
	else
		vim.fn.setqflist({}, ' ', list)
		require("trouble").toggle("quickfix")
	end
end

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = true,
		signs = true,
		update_in_insert = true,
	}
)
