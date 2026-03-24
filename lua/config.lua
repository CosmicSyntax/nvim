-- Treesitter
require 'nvim-treesitter'.setup {
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
require 'nvim-treesitter'.install {
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
	"http",
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
			find_command = { "fd", "--type", "f", "--no-ignore", "--hidden", "--exclude", ".git", "--exclude", "target" },
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

-- Enable diagnostics
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = true,
})
