-- ==========================================
-- 1. Treesitter
-- ==========================================
require('nvim-treesitter').setup {
	highlight = { enable = true },
	indent = { enable = true },
	autopairs = { enable = true },
}
require('nvim-treesitter').install {
	"c", "lua", "vim", "rust", "zig", "go", "python", "bash", "typescript",
	"cpp", "sql", "html", "markdown", "markdown_inline", "terraform", "vimdoc",
	"regex", "toml", "yaml", "helm", "dockerfile", "http",
}

-- ==========================================
-- 2. Telescope
-- ==========================================
local telescope = require("telescope")
telescope.setup {
	defaults = {
		vimgrep_arguments = {
			'rg', '--no-heading', '--with-filename', '--line-number',
			'--column', '--smart-case', '--glob', '!**/Cargo.lock',
		},
	},
	pickers = {
		find_files = {
			find_command = { "fd", "--type", "f", "--no-ignore", "--hidden", "--exclude", ".git", "--exclude", "target" },
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown {}
		}
	}
}
telescope.load_extension('fzf')
telescope.load_extension("ui-select")

-- ==========================================
-- 3. Colorscheme (Nord)
-- ==========================================
require("nord").setup({
	transparent = false,
	terminal_colors = true,
	diff = { mode = "bg" },
	borders = true,
	errors = { mode = "bg" },
	search = { theme = "vim" },
	styles = {
		comments = { italic = true },
		keywords = {},
		functions = { bold = true },
		variables = {},
	},
})

vim.cmd("colorscheme nord")

-- Wrap overrides in an augroup so they persist if the colorscheme is ever reloaded
local hl_group = vim.api.nvim_create_augroup("CustomHighlights", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = hl_group,
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, 'LineNr', { fg = "#ebcb8b" })
		vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = "#4c566a" })
		vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = "#4c566a" })
		vim.api.nvim_set_hl(0, 'WinSeparator', { fg = "#4c566a" })
		vim.api.nvim_set_hl(0, 'NeogitDiffAddHighlight', { link = 'DiffAdd' })
		vim.api.nvim_set_hl(0, 'NeogitDiffDeleteHighlight', { link = 'DiffDelete' })
		vim.api.nvim_set_hl(0, 'NeogitDiffAdd', { link = 'DiffAdd' })
		vim.api.nvim_set_hl(0, 'NeogitDiffDelete', { link = 'DiffDelete' })
	end,
})

-- ==========================================
-- 4. Diagnostics
-- ==========================================
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = true,
})
