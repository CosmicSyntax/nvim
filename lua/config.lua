-- Treesitter
require 'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"rust",
		"zig",
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
		"helm",
		"dockerfile",
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

-- Update references to default to Trouble
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

---@param method string
---@param opts? vim.lsp.LocationOpts
local function get_locations(method, opts)
	opts = opts or {}
	local bufnr = api.nvim_get_current_buf()
	local clients = lsp.get_clients({ method = method, bufnr = bufnr })
	if not next(clients) then
		vim.notify(lsp._unsupported_method(method), vim.log.levels.WARN)
		return
	end
	local win = api.nvim_get_current_win()
	local from = vim.fn.getpos('.')
	from[1] = bufnr
	local tagname = vim.fn.expand('<cword>')
	local remaining = #clients

	---@type vim.quickfix.entry[]
	local all_items = {}

	---@param result nil|lsp.Location|lsp.Location[]
	---@param client vim.lsp.Client
	local function on_response(_, result, client)
		local locations = {}
		if result then
			locations = vim.islist(result) and result or { result }
		end
		local items = util.locations_to_items(locations, client.offset_encoding)
		vim.list_extend(all_items, items)
		remaining = remaining - 1
		if remaining == 0 then
			if vim.tbl_isempty(all_items) then
				vim.notify('No locations found', vim.log.levels.INFO)
				return
			end

			local title = 'LSP locations'
			if opts.on_list then
				assert(vim.is_callable(opts.on_list), 'on_list is not a function')
				opts.on_list({
					title = title,
					items = all_items,
					context = { bufnr = bufnr, method = method },
				})
				return
			end

			if #all_items == 1 then
				local item = all_items[1]
				local b = item.bufnr or vim.fn.bufadd(item.filename)

				-- Save position in jumplist
				vim.cmd("normal! m'")
				-- Push a new item into tagstack
				local tagstack = { { tagname = tagname, from = from } }
				vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, 't')

				vim.bo[b].buflisted = true
				local w = opts.reuse_win and vim.fn.win_findbuf(b)[1] or win
				api.nvim_win_set_buf(w, b)
				api.nvim_win_set_cursor(w, { item.lnum, item.col - 1 })
				vim._with({ win = w }, function()
					-- Open folds under the cursor
					vim.cmd('normal! zv')
				end)
				return
			end
			if opts.loclist then
				vim.fn.setloclist(0, {}, ' ', { title = title, items = all_items })
				require("trouble").toggle("quickfix")
			else
				vim.fn.setqflist({}, ' ', { title = title, items = all_items })
				require("trouble").toggle("quickfix")
			end
		end
	end
	for _, client in ipairs(clients) do
		local params = util.make_position_params(win, client.offset_encoding)
		client:request(method, params, function(_, result)
			on_response(_, result, client)
		end)
	end
end

vim.lsp.buf.definition = function(opts)
	get_locations(ms.textDocument_definition, opts)
end

vim.lsp.buf.implementation = function(opts)
	get_locations(ms.textDocument_implementation, opts)
end

vim.lsp.buf.type_definition = function(opts)
	get_locations(ms.textDocument_typeDefinition, opts)
end

vim.lsp.buf.declaration = function(opts)
	get_locations(ms.textDocument_documentSymbol, opts)
end

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
