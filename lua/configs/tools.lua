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
require'diffview'.setup {
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
		},
	},
}

-- Smooth scrolling
require('neoscroll').setup {
	easing_function = "quadratic",
}

-- Window management
require('windows').setup({
	autowidth = {
		winwidth = 15,
	}
})

-- Nvim autopair
require'nvim-autopairs'.setup {}

-- Nvim Comment
require('Comment').setup()

-- Nvim Git linker
require("gitlinker").setup()
