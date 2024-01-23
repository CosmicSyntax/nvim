-- Custom Statusline... work in progress
local modes = {
	["n"] = "NORMAL",
	["V"] = "VISUAL LINE",
	[""] = "VISUAL BLOCK",
	["s"] = "SELECT",
	["S"] = "SELECT LINE",
	[""] = "SELECT BLOCK",
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
	midBlue = "#4c566a",
	lightBlue = "#81a1c1",
	red = "#bf616a",
	blue = "#5e81ac",
	yellow = "#ebcb8b",
	purple = "#b48ead",
	green = "#a3be8c",
	orange = "#d08770",
}

-- TODO: replace hardcoded colors to local variables
local highlights = {
	{ 'StatusLine',            { fg = colors.darkBlue, bg = colors.lightBlue, gui = 'bold' } },
	{ 'StatusLineRed',         { fg = colors.darkBlue, bg = colors.red, gui = 'bold' } },
	{ 'StatusLineBlue',        { fg = colors.darkBlue, bg = colors.blue, gui = 'bold' } },
	{ 'StatusLineYellow',      { fg = colors.darkBlue, bg = colors.yellow, gui = 'bold' } },
	{ 'StatusLinePurple',      { fg = colors.darkBlue, bg = colors.purple, gui = 'bold' } },
	{ 'StatusLineGreen',       { fg = colors.darkBlue, bg = colors.green, gui = 'bold' } },
	{ 'StatusLineExtra',       { bg = '#434c5e' } },
	{ 'StatusLineMiddle',      { bg = '#3b4252' } },
	-- for Git
	{ 'GitAdd',                { fg = colors.green, bg = colors.midBlue } },
	{ 'GitChange',             { fg = colors.yellow, bg = colors.midBlue } },
	{ 'GitDelete',             { fg = colors.red, bg = colors.midBlue } },
	-- for FS
	{ 'StatusLineFS',          { fg = '#d8dee9', bg = colors.midBlue } },
	-- for Diagnostic
	{ 'DxError',               { fg = colors.red, bg = colors.midBlue } },
	{ 'DxWarn',                { fg = colors.orange, bg = colors.midBlue } },
	{ 'DxHint',                { fg = colors.purple, bg = colors.midBlue } },
	{ 'DxInfo',                { fg = colors.blue, bg = colors.midBlue } },
	{ 'StatusLineDivide',      { fg = colors.midBlue, bg = '#3b4252' } },
	-- for symbols
	{ 'StatusLineTrail',       { fg = colors.lightBlue, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineRedTrail',    { fg = colors.red, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineBlueTrail',   { fg = colors.blue, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineYellowTrail', { fg = colors.yellow, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLinePurpleTrail', { fg = colors.purple, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineGreenTrail',  { fg = colors.green, bg = colors.midBlue, gui = 'bold' } },
	{ 'StatusLineExtraTrail',  { bg = '#3b4252', fg = '#434c5e' } },
	-- { 'Normal',                        { fg = '#d8dee9', bg = colors.darkBlue } },
	-- { 'LspDiagnosticsSignError',       { fg = colors.red, gui = 'bold' } },
	-- { 'LspDiagnosticsSignWarning',     { fg = '#d08770', gui = 'bold' } },
	-- { 'LspDiagnosticsSignHint',        { fg = '#b988b0', gui = 'bold' } },
	-- { 'LspDiagnosticsSignInformation', { fg = colors.purple, gui = 'bold' } },
}

local statuline_symbols = {
	right = {
		arrow = "",
	},
	left = {
		arrow = "",
	},
}

local function mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return string.format(" %s ", modes[current_mode]):upper()
end

local set_hl = function(group, options)
	local bg = options.bg == nil and '' or 'guibg=' .. options.bg
	local fg = options.fg == nil and '' or 'guifg=' .. options.fg
	local gui = options.gui == nil and '' or 'gui=' .. options.gui

	vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
end

for _, highlight in ipairs(highlights) do
	set_hl(highlight[1], highlight[2])
end

local function update_mode_colors()
	local current_mode = vim.api.nvim_get_mode().mode
	local mode_color = "%#StatusLine#"
	if current_mode == "n" then
		mode_color = "%#StatusLine#"
	elseif current_mode == "i" or current_mode == "ic" then
		mode_color = "%#StatusLineYellow#"
	elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
		mode_color = "%#StatusLineBlue#"
	elseif current_mode == "R" then
		mode_color = "%#StatusLineRed#"
	elseif current_mode == "c" then
		mode_color = "%#StatusLinePurple#"
	elseif current_mode == "t" then
		mode_color = "%#StatusLineGreen#"
	end
	return mode_color
end

local function update_mode_colors_trailing()
	local current_mode = vim.api.nvim_get_mode().mode
	local mode_color = "%#StatusLineTrail#"
	if current_mode == "n" then
		mode_color = "%#StatusLineTrail#"
	elseif current_mode == "i" or current_mode == "ic" then
		mode_color = "%#StatusLineYellowTrail#"
	elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
		mode_color = "%#StatusLineBlueTrail#"
	elseif current_mode == "R" then
		mode_color = "%#StatusLineRedTrail#"
	elseif current_mode == "c" then
		mode_color = "%#StatusLinePurpleTrail#"
	elseif current_mode == "t" then
		mode_color = "%#StatusLineGreenTrail#"
	end
	return mode_color
end

local function file()
	local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
	local fname = vim.fn.expand "%:t"

	if fname == "" or fpath == "" then
		return ""
	end

	return string.format(" %%<%s/", fpath) .. fname .. " "
end

local function lsp()
	local count = {}
	local levels = {
		errors = "Error",
		warnings = "Warn",
		info = "Info",
		hints = "Hint",
	}

	for k, level in pairs(levels) do
		count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
	end

	local errors = ""
	local warnings = ""
	local hints = ""
	local info = ""

	if count["errors"] ~= 0 then
		errors = "%#DxError# " .. count["errors"] .. " "
	end
	if count["warnings"] ~= 0 then
		warnings = "%#DxWarn# " .. count["warnings"] .. " "
	end
	if count["hints"] ~= 0 then
		hints = "%#DxHint# " .. count["hints"] .. " "
	end
	if count["info"] ~= 0 then
		info = "%#DxInfo#🛈 " .. count["info"] .. " "
	end

	if count["errors"] == 0 and count["warnings"] == 0 and count["hints"] == 0 and count["info"] == 0 then
		return ""
	end

	return errors .. warnings .. hints .. info
end

local function filetype()
	-- return string.format(" %s ", vim.bo.filetype):upper()
	local icon, color = require("nvim-web-devicons").get_icon_colors_by_filetype(vim.bo.filetype)
	local ft = vim.bo.filetype:upper()
	if ft == "" then
		return " "
	end
	if icon == nil then
		return " " .. ft .. " "
	end

	set_hl("IconColor", { fg = color, bg = "#434c5e", gui = "bold" })

	return "%#IconColor#" .. string.format(" %s %s ", icon, ft) .. "%#StatusLineExtra#"
end

local function lineinfo()
	if vim.bo.filetype == "alpha" then
		return ""
	end
	-- return "%P Ln:%l Col:%c "
	return "%P Column:%c "
end

local function vcs()
	local git_info = vim.b.gitsigns_status_dict
	if not git_info or git_info.head == "" then
		return ""
	end
	local added = git_info.added and (" " .. "%#GitAdd#+" .. git_info.added) or ""
	local changed = git_info.changed and (" " .. "%#GitChange#~" .. git_info.changed) or ""
	local removed = git_info.removed and (" " .. "%#GitDelete#-" .. git_info.removed) or ""
	if git_info.added == 0 then
		added = ""
	end
	if git_info.changed == 0 then
		changed = ""
	end
	if git_info.removed == 0 then
		removed = ""
	end
	return table.concat {
		"%#GitAdd#  ",
		git_info.head,
		added,
		changed,
		removed,
		-- "%#Normal#",
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

function Statusline.inactive()
	return " %F"
end

function Statusline.short()
	return "%#StatusLineNC#   NvimTree"
end

vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
  augroup END
]], false)
vim.o.laststatus = 3
