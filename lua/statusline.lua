-- Custom Statusline... work in progress
local modes = {
	["n"] = "NORMAL",
	["no"] = "NORMAL",
	["v"] = "VISUAL",
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

local highlights = {
	{'StatusLine', { fg = '#4c566a', bg = '#8fbcbb', gui= 'bold' }},
	{'StatusLineRed', { fg = '#4c566a', bg = '#bf616a', gui= 'bold' }},
	{'StatusLineBlue', { fg = '#4c566a', bg = '#5e81ac', gui= 'bold' }},
	{'StatusLineYellow', { fg = '#4c566a', bg = '#ebcb8b', gui= 'bold' }},
	{'StatusLinePurple', { fg = '#4c566a', bg = '#b48ead', gui= 'bold' }},
	{'StatusLineGreen', { fg = '#4c566a', bg = '#a3be8c', gui= 'bold' }},
	{'Normal', { fg = '#d8dee9', bg = '#2e3440' }},
	{'StatusLineExtra', { fg = '#d8dee9', bg = '#4c566a' }},
}

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

local function filepath()
	local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
	if fpath == "" or fpath == "." then
		return " "
	end

	return string.format(" %%<%s/", fpath)
end

local function filename()
	local fname = vim.fn.expand "%:t"
	if fname == "" then
		return ""
	end
	return fname .. " "
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
		errors = " %#LspDiagnosticsSignError# " .. count["errors"]
	end
	if count["warnings"] ~= 0 then
		warnings = " %#LspDiagnosticsSignWarning# " .. count["warnings"]
	end
	if count["hints"] ~= 0 then
		hints = " %#LspDiagnosticsSignHint# " .. count["hints"]
	end
	if count["info"] ~= 0 then
		info = " %#LspDiagnosticsSignInformation# " .. count["info"]
	end

	return errors .. warnings .. hints .. info .. "%#Normal#"
end

local function filetype()
	-- return string.format(" %s ", vim.bo.filetype):upper()
	local icon = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype)
	if icon == nil then
		icon = ""
	end
	return string.format(" %s %s ", icon, vim.bo.filetype):upper()
end

local function lineinfo()
	if vim.bo.filetype == "alpha" then
		return ""
	end
	return " %P Ln:%l Col:%c "
end

local function vcs()
	local git_info = vim.b.gitsigns_status_dict
	if not git_info or git_info.head == "" then
		return ""
	end
	local added = git_info.added and ("%#GitSignsAdd#+" .. git_info.added .. " ") or ""
	local changed = git_info.changed and ("%#GitSignsChange#~" .. git_info.changed .. " ") or ""
	local removed = git_info.removed and ("%#GitSignsDelete#-" .. git_info.removed .. " ") or ""
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
		"%#GitSignsAdd# ",
		git_info.head,
		" ",
		added,
		changed,
		removed,
		" %#Normal#",
	}
end

local function statusline_lsp()

	-- return 'test'
	-- vim.g.indicator_errors = ''
	-- vim.g.indicator_warnings = ''
	-- vim.g.indicator_info = '🛈'
	-- vim.g.indicator_hint = '❗'
	-- vim.g.indicator_ok = ''
	-- vim.g.spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'}

	-- local base_status = "S"
	local status_symbol = ' '
	-- local indicator_ok = '✅'
	-- vim.g.indicator_errors = ''
	-- vim.g.indicator_warnings = ''
	-- vim.g.indicator_info = '🛈'
	-- vim.g.indicator_hint = '❗'
	-- vim.g.indicator_ok = '✅'

	-- can we ?
	if #vim.lsp.buf_get_clients() == 0 then
		return ' no LSP clients'
	end

	local msgs = {}
	local buf_messages = vim.lsp.util.get_progress_messages()

	for _, msg in ipairs(buf_messages) do
		-- print("statusline ", vim.inspect(msg))
		local client_name = '[' .. msg.name .. ']'
		local contents = ''
		if msg.progress then
			contents = msg.title
			if msg.message then
				contents = contents .. ' ' .. msg.message
			end

			if msg.percentage then
				contents = contents .. ' (' .. msg.percentage .. ')'
			end

		elseif msg.status then
			contents = msg.content
			if msg.uri then
				local filename = vim.uri_to_fname(msg.uri)
				filename = vim.fn.fnamemodify(filename, ':~:.')
				local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
				if #filename > space then
					filename = vim.fn.pathshorten(filename)
				end

				contents = '(' .. filename .. ') ' .. contents
			end
		else
			contents = msg.content
		end

		table.insert(msgs, client_name .. ' ' .. contents)
	end
	-- vim.trim(table.concat(status_parts, ' ') ..
	local base_status =  ' ' .. table.concat(msgs, ' ')
	local symbol = status_symbol
	-- .. ((some_diagnostics and only_hint) and '' or ' ')
	local current_function = vim.b.lsp_current_function
	if current_function and current_function ~= '' then
		symbol = symbol .. '(' .. current_function .. ') '
	end

	if base_status ~= '' then
		return symbol .. base_status .. ' '
	end

	return symbol .. indicator_ok .. ' '
	-- return 'test'
end

Statusline = {}

Statusline.active = function()
	return table.concat {
		update_mode_colors(),
		mode(),
		"%#Normal# ",
		vcs(),
		filepath(),
		filename(),
		"%#Normal#",
		lsp(),
		"%=%#StatusLineExtra#",
		statusline_lsp(),
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
