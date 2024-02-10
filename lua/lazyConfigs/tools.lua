-- Inlay hints
-- require("lsp-inlayhints").setup({
-- 	inlay_hints = {
-- 		parameter_hints = {
-- 			show = false,
-- 			prefix = "<- ",
-- 			separator = ", ",
-- 			remove_colon_start = false,
-- 			remove_colon_end = true,
-- 		},
-- 		type_hints = {
-- 		-- type and other hints
-- 			show = true,
-- 			prefix = "-> ",
-- 			separator = ", ",
-- 			remove_colon_start = true,
-- 			remove_colon_end = true,
-- 		},
-- 		only_current_line = false,
-- 		-- separator between types and parameter hints. Note that type hints are
-- 		-- shown before parameter
-- 		labels_separator = "",
-- 		-- whether to align to the length of the longest line in the file
-- 		max_len_align = false,
-- 		-- padding from the left if max_len_align is true
-- 		max_len_align_padding = 1,
-- 		-- highlight group
-- 		-- highlight = "LspInlayHint",
-- 		highlight = "Comment",
-- 		-- virt_text priority
-- 		priority = 0,
-- 	},
-- 	enabled_at_startup = true,
-- 	debug_mode = false,
-- })

-- Trouble - dx
require("trouble").setup {
	icons = true,
	action_keys = {
		close_folds = "tc",
		open_folds = "to",
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
