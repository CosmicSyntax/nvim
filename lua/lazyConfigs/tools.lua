-- Trouble - dx
require("trouble").setup {
	auto_close = false, -- auto close when there are no items
	auto_open = false, -- auto open when there are items
	auto_preview = true, -- automatically open preview when on an item
	auto_refresh = true, -- auto refresh when open
	auto_jump = false, -- auto jump to the item when there's only one
	focus = false,     -- Focus the window when opened
	restore = true,    -- restores the last location in the list when opening
	follow = true,     -- Follow the current item
	indent_guides = true, -- show indent guides
	max_items = 200,   -- limit number of items that can be displayed per section
	multiline = true,  -- render multi-line messages
	pinned = false,    -- When pinned, the opened trouble window will be bound to the current buffer
	---@type trouble.Window.opts
	win = {},          -- window options for the results window. Can be a split or a floating window.
	-- Window options for the preview window. Can be a split, floating window,
	-- or `main` to show the preview in the main editor window.
	---@type trouble.Window.opts
	preview = {
		type = "main",
		-- when a buffer is not yet loaded, the preview window will be created
		-- in a scratch buffer with only syntax highlighting enabled.
		-- Set to false, if you want the preview to always be a real loaded buffer.
		scratch = true,
	},
	-- Throttle/Debounce settings. Should usually not be changed.
	---@type table<string, number|{ms:number, debounce?:boolean}>
	throttle = {
		refresh = 20,                      -- fetches new data when needed
		update = 10,                       -- updates the window
		render = 10,                       -- renders the window
		follow = 100,                      -- follows the current item
		preview = { ms = 100, debounce = true }, -- shows the preview for the current item
	},
	-- Key mappings can be set to the name of a builtin action,
	-- or you can define your own custom action.
	---@type table<string, string|trouble.Action>
	keys = {
		["?"] = "help",
		r = "refresh",
		R = "toggle_refresh",
		q = "close",
		o = "jump_close",
		["<esc>"] = "cancel",
		["<cr>"] = "jump",
		["<2-leftmouse>"] = "jump",
		["<c-s>"] = "jump_split",
		["<c-v>"] = "jump_vsplit",
		-- go down to next item (accepts count)
		-- j = "next",
		["}"] = "next",
		["]]"] = "next",
		-- go up to prev item (accepts count)
		-- k = "prev",
		["{"] = "prev",
		["[["] = "prev",
		i = "inspect",
		p = "preview",
		P = "toggle_preview",
		zo = "fold_open",
		zO = "fold_open_recursive",
		zc = "fold_close",
		zC = "fold_close_recursive",
		za = "fold_toggle",
		zA = "fold_toggle_recursive",
		zm = "fold_more",
		zM = "fold_close_all",
		zr = "fold_reduce",
		zR = "fold_open_all",
		zx = "fold_update",
		zX = "fold_update_all",
		zn = "fold_disable",
		zN = "fold_enable",
		zi = "fold_toggle_enable",
		gb = { -- example of a custom action that toggles the active view filter
			action = function(view)
				view.state.filter_buffer = not view.state.filter_buffer
				view:filter(view.state.filter_buffer and { buf = 0 } or nil)
			end,
			desc = "Toggle Current Buffer Filter",
		},
	},
	---@type table<string, trouble.Mode>
	modes = {
		symbols = {
			desc = "document symbols",
			mode = "lsp_document_symbols",
			focus = false,
			win = { position = "right" },
			filter = {
				-- remove Package since luals uses it for control flow structures
				["not"] = { ft = "lua", kind = "Package" },
				any = {
					-- all symbol kinds for help / markdown files
					ft = { "help", "markdown" },
					-- default set of symbol kinds
					kind = {
						"Class",
						"Constructor",
						"Enum",
						"Field",
						"Function",
						"Interface",
						"Method",
						"Module",
						"Namespace",
						"Package",
						"Property",
						"Struct",
						"Trait",
					},
				},
			},
		},
	},
	-- stylua: ignore
	icons = {
		---@type trouble.Indent.symbols
		indent        = {
			top         = "│ ",
			middle      = "├╴",
			last        = "└╴",
			-- last          = "-╴",
			-- last       = "╰╴", -- rounded
			fold_open   = " ",
			fold_closed = " ",
			ws          = "  ",
		},
		folder_closed = " ",
		folder_open   = " ",
		kinds         = {
			Array         = " ",
			Boolean       = "󰨙 ",
			Class         = " ",
			Constant      = "󰏿 ",
			Constructor   = " ",
			Enum          = " ",
			EnumMember    = " ",
			Event         = " ",
			Field         = " ",
			File          = " ",
			Function      = "󰊕 ",
			Interface     = " ",
			Key           = " ",
			Method        = "󰊕 ",
			Module        = " ",
			Namespace     = "󰦮 ",
			Null          = " ",
			Number        = "󰎠 ",
			Object        = " ",
			Operator      = " ",
			Package       = " ",
			Property      = " ",
			String        = " ",
			Struct        = "󰆼 ",
			TypeParameter = " ",
			Variable      = "󰀫 ",
		},
	},
}

-- Gitsigns
require('gitsigns').setup({
	current_line_blame = false,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'eol',
		delay = 1000,
		ignore_whitespace = false,
	},
})

-- Diffview Config
require 'diffview'.setup {
	diff_binaries = false,
	enhanced_diff_hl = false,
	use_icons = true,
	file_panel = {
		win_config = {
			position = "left",
			width = 35,
			height = 10,
		},
		listing_style = "tree",
		tree_options = {
			flatten_dirs = true,
			folder_statuses = "always"
		}
	},
	file_history_panel = {
		win_config = {
			position = "bottom",
			width = 35,
			height = 16,
		},
		log_options = {
			git = {
				single_file = {
					max_count = 256,
					follow = false,
					all = false,
					merges = false,
					no_merges = false,
					reverse = false,
				},
				multi_file = {
					max_count = 256,
					follow = false,
					all = false,
					merges = false,
					no_merges = false,
					reverse = false,
				},
			}
		},
	},
}

-- Smooth scrolling
require('neoscroll').setup {
	easing_function = "sine",
}

-- Blink Config
require('blink.cmp').setup({
	keymap = {
		preset = 'none',
		['<C-Tab>'] = { 'show', 'show_documentation', 'hide_documentation', "fallback" },
		['<CR>'] = { 'select_and_accept', 'fallback' },

		-- ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
		-- ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

		['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
		['<C-j>'] = { 'scroll_documentation_down', 'fallback' },

		['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
		['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
	},
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = 'mono'
	},
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = {
		enabled = true,
		-- window = {
		-- 	winblend = 30,
		-- },
	},
})
-- Copilot with Blink
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "BlinkCmpMenuOpen",
-- 	callback = function()
-- 		vim.b.copilot_suggestion_hidden = true
-- 	end,
-- })
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "BlinkCmpMenuClose",
-- 	callback = function()
-- 		vim.b.copilot_suggestion_hidden = false
-- 	end,
-- })

-- Window management
require('windows').setup({
	autowidth = {
		winwidth = 15,
	}
})

-- Nvim autopair
require 'nvim-autopairs'.setup {}

require("fidget").setup {
	progress = {
		lsp = {
			progress_ringbuf_size = 2048,
		},
	},
}

-- Nvim Comment
require('Comment').setup()

-- Nvim Git linker
require("gitlinker").setup()

-- Nvim indent-line
vim.cmd("highlight CustomTabColor guibg=#363c4a")
local highlight = {
	"CustomTabColor",
	"Whitespace",
}
require("ibl").setup {
	indent = { highlight = highlight, char = "" },
	whitespace = {
		highlight = highlight,
		remove_blankline_trail = false,
	},
	scope = { enabled = false },
}
