-- Custom Statusline
local modes = {
	["n"] = "NORMAL",
	["V"] = "VISUAL LINE",
	["v"] = "VISUAL",
	["s"] = "SELECT",
	["S"] = "SELECT LINE",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "REPLACE",
	["Rv"] = "VISUAL REPLACE",
	["c"] = "COMMAND",
	["cv"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

local colors = {
	darkBlue = "#2e3440",
	muteBlue = "#3b4252",
	mutelightBlue = "#434c5e",
	midBlue = "#4c566a",
	lightBlue = "#81a1c1",
	red = "#bf616a",
	blue = "#5e81ac",
	yellow = "#ebcb8b",
	purple = "#b48ead",
	green = "#a3be8c",
	orange = "#d08770",
	white = "#d8dee9",
}

local highlights = {
	{ 'StatusLine',            { fg = colors.darkBlue, bg = colors.lightBlue, gui = 'bold' } },
	{ 'StatusLineRed',         { fg = colors.darkBlue, bg = colors.red, gui = 'bold' } },
	{ 'StatusLineBlue',        { fg = colors.darkBlue, bg = colors.blue, gui = 'bold' } },
	{ 'StatusLineYellow',      { fg = colors.darkBlue, bg = colors.yellow, gui = 'bold' } },
	{ 'StatusLinePurple',      { fg = colors.darkBlue, bg = colors.purple, gui = 'bold' } },
	{ 'StatusLineGreen',       { fg = colors.darkBlue, bg = colors.green, gui = 'bold' } },
	{ 'StatusLineOrange',      { fg = colors.darkBlue, bg = colors.orange, gui = 'bold' } },
	{ 'StatusLineExtra',       { fg = colors.white, bg = colors.muteBlue } },
	{ 'StatusLineMiddle',      { bg = colors.mutelightBlue } },
	{ 'GitAdd',                { fg = colors.green, bg = colors.midBlue } },
	{ 'GitChange',             { fg = colors.yellow, bg = colors.midBlue } },
	{ 'GitDelete',             { fg = colors.red, bg = colors.midBlue } },
	{ 'StatusLineFS',          { fg = colors.white, bg = colors.midBlue } },
	{ 'DxError',               { fg = colors.red, bg = colors.midBlue } },
	{ 'DxWarn',                { fg = colors.orange, bg = colors.midBlue } },
	{ 'DxHint',                { fg = colors.purple, bg = colors.midBlue } },
	{ 'DxInfo',                { fg = colors.blue, bg = colors.midBlue } },
	{ 'StatusLineDivide',      { fg = colors.midBlue, bg = colors.mutelightBlue } },
	{ 'StatusLineTrail',       { fg = colors.lightBlue, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineRedTrail',    { fg = colors.red, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineBlueTrail',   { fg = colors.blue, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineYellowTrail', { fg = colors.yellow, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLinePurpleTrail', { fg = colors.purple, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineGreenTrail',  { fg = colors.green, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineOrangeTrail', { fg = colors.orange, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineExtraTrail',  { bg = colors.mutelightBlue, fg = colors.muteBlue } },
}

local statuline_symbols = {
	right = { arrow = "" },
	left = { arrow = "" },
}

local black_placeholder = "    "

-- Modern Highlight Setter
local set_hl = function(group, options)
	vim.api.nvim_set_hl(0, group, {
		fg = options.fg,
		bg = options.bg,
		bold = options.gui == 'bold'
	})
end

for _, highlight in ipairs(highlights) do
	set_hl(highlight[1], highlight[2])
end

local function mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return string.format(" %s ", modes[current_mode] or "UNKNOWN"):upper()
end

-- Fast Table Lookups for Mode Colors
local mode_colors = {
	n = "%#StatusLine#",
	i = "%#StatusLineYellow#",
	ic = "%#StatusLineYellow#",
	v = "%#StatusLineBlue#",
	V = "%#StatusLineBlue#",
	["\22"] = "%#StatusLineBlue#",
	s = "%#StatusLineOrange#",
	S = "%#StatusLineOrange#",
	R = "%#StatusLineRed#",
	c = "%#StatusLinePurple#",
	t = "%#StatusLineGreen#"
}

local mode_colors_trailing = {
	n = "%#StatusLineTrail#",
	i = "%#StatusLineYellowTrail#",
	ic = "%#StatusLineYellowTrail#",
	v = "%#StatusLineBlueTrail#",
	V = "%#StatusLineBlueTrail#",
	["\22"] = "%#StatusLineBlueTrail#",
	s = "%#StatusLineOrangeTrail#",
	S = "%#StatusLineOrangeTrail#",
	R = "%#StatusLineRedTrail#",
	c = "%#StatusLinePurpleTrail#",
	t = "%#StatusLineGreenTrail#"
}

local function update_mode_colors()
	local m = vim.api.nvim_get_mode().mode
	return mode_colors[m] or "%#StatusLine#"
end

local function update_mode_colors_trailing()
	local m = vim.api.nvim_get_mode().mode
	return mode_colors_trailing[m] or "%#StatusLineBlueTrail#"
end

local function file()
	local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
	local fname = vim.fn.expand "%:t"

	if fname == "" or fpath == "" then
		return ""
	end

	return string.format(" %%<%s/", fpath) .. fname .. " "
end

-- Optimized Diagnostic Fetching
local function lsp()
	local count = { errors = 0, warnings = 0, info = 0, hints = 0 }

	if vim.fn.has("nvim-0.10") == 1 then
		local diags = vim.diagnostic.count(0)
		count.errors = diags[vim.diagnostic.severity.ERROR] or 0
		count.warnings = diags[vim.diagnostic.severity.WARN] or 0
		count.info = diags[vim.diagnostic.severity.INFO] or 0
		count.hints = diags[vim.diagnostic.severity.HINT] or 0
	else
		count.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		count.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		count.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		count.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	end

	local out = {}
	if count.errors > 0 then table.insert(out, "%#DxError# " .. count.errors .. " ") end
	if count.warnings > 0 then table.insert(out, "%#DxWarn# " .. count.warnings .. " ") end
	if count.hints > 0 then table.insert(out, "%#DxHint# " .. count.hints .. " ") end
	if count.info > 0 then table.insert(out, "%#DxInfo#🛈 " .. count.info .. " ") end

	if #out == 0 then return "" end
	return table.concat(out)
end

local function filetype()
	local icon, color = require("nvim-web-devicons").get_icon_colors_by_filetype(vim.bo.filetype)
	local ft = vim.bo.filetype:upper()
	if ft == "" then
		return "     " .. black_placeholder .. "     "
	end
	if icon == nil then
		return " " .. ft .. " "
	end

	set_hl("IconColor", { fg = color, bg = colors.muteBlue, gui = "bold" })

	return "%#IconColor#" .. string.format(" %s %s ", icon, ft) .. "%#StatusLineExtra#"
end

local function lineinfo()
	if vim.fn.expand "%P" == "" then
		return ""
	end
	return "%P Column:%c "
end

local function vcs()
	local git_info = vim.b.gitsigns_status_dict
	if not git_info or git_info.head == "" then
		return ""
	end
	local added = git_info.added and git_info.added > 0 and (" " .. "%#GitAdd#+" .. git_info.added) or ""
	local changed = git_info.changed and git_info.changed > 0 and (" " .. "%#GitChange#~" .. git_info.changed) or ""
	local removed = git_info.removed and git_info.removed > 0 and (" " .. "%#GitDelete#-" .. git_info.removed) or ""

	return table.concat {
		"%#GitAdd#  ",
		git_info.head,
		added,
		changed,
		removed,
	}
end

Statusline = {}

Statusline.active = function()
	return table.concat {
		update_mode_colors(),
		mode(),
		update_mode_colors_trailing(),
		statuline_symbols.right.arrow,
		vcs(),
		"%#StatusLineFS#",
		file(),
		lsp(),
		"%#StatusLineDivide#",
		statuline_symbols.right.arrow,
		"%#StatusLineMiddle#",
		"%=%#StatusLineExtraTrail#",
		statuline_symbols.left.arrow,
		"%#StatusLineExtra#",
		filetype(),
		lineinfo(),
	}
end

function Statusline.short()
	return table.concat {
		"%#StatusLineFS#",
		"%=",
		black_placeholder,
		"%=%",
	}
end

-- Modern Autocommands
vim.o.laststatus = 3

local stl_group = vim.api.nvim_create_augroup("StatuslineGroup", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = stl_group,
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "NvimTree" then
			vim.wo.statusline = "%!v:lua.Statusline.short()"
		else
			vim.wo.statusline = "%!v:lua.Statusline.active()"
		end
	end
})
