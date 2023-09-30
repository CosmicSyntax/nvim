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

require("fidget").setup {}

-- Nvim Comment
require('Comment').setup()

-- Nvim Git linker
require("gitlinker").setup()

-- Nvim indent-line
-- require("ibl").setup {
-- 	indent = { char = "▏" },
-- 	scope = {
-- 		enabled = false,
-- 	},
-- }

-- Tabline config
require('bufferline').setup {
	highlights = {
		buffer_selected = {
			bold = true,
			italic = false,
		},
		error_selected = {
			bold = true,
		},
		error_diagnostic_selected = {
			bold = true,
		},
		info_selected = {
			bold = true,
		},
		info_diagnostic_selected = {
			bold = true,
		},
		warning_selected = {
			bold = true,
		},
		warning_diagnostic_selected = {
			bold = true,
		},
		-- duplicate_selected = {
		-- 	gui = None,
		-- },
		-- duplicate_visible = {
		-- 	gui = None,
		-- },
		-- duplicate = {
		-- 	gui = None,
		-- },
	},
	options = {
		-- diagnostics = "nvim_lsp",
		-- diagnostics_update_in_insert = false,
		-- diagnostics_indicator = function(count, level, diagnostics_dict, context)
		-- 	return "("..count..")"
		-- end,
		offsets = {
			{
				filetype = "NvimTree",
				text = "Navigation", 
				text_align = "center",
				padding = 0,
			}
		},
		buffer_close_icon = 'x',
		show_buffer_icons = true,
		show_buffer_close_icons = false,
		show_close_icon = false,
		show_tab_indicators = true,
		persist_buffer_sort = true,
		separator_style = "thin",
		-- custom_areas = {
		-- 	right = function()
		-- 		local result = {}
  --
		-- 		local error = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})
		-- 		local warning = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})
		-- 		local info = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO})
		-- 		local hint = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT})
  --
		-- 		if error ~= 0 then
		-- 			table.insert(result, {text = " E " .. error, guifg = "#EC5241"})
		-- 		end
  --
		-- 		if warning ~= 0 then
		-- 			table.insert(result, {text = " W " .. warning, guifg = "#EFB839"})
		-- 		end
  --
		-- 		if hint ~= 0 then
		-- 			table.insert(result, {text = " H " .. hint, guifg = "#A3BA5E"})
		-- 		end
  --
		-- 		if info ~= 0 then
		-- 			table.insert(result, {text = " I " .. info, guifg = "#7EA9A7"})
		-- 		end
		-- 		return result
		-- 	end,
		-- }
	},
}
