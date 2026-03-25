local M = {}
local util = require("lazyConfigs.rustUtils.utils")

local function add_header(lines, header)
    local new_lines = vim.deepcopy(lines)
    local header_str = "// " .. header
    table.insert(new_lines, 1, "")
    table.insert(new_lines, 1, "// " .. string.rep("=", string.len(header_str) - 3))
    table.insert(new_lines, 1, header_str)
    return new_lines
end

VIEWS = {}

function M.open(tag, view, header, filetype)
    if VIEWS[tag] == nil then
        VIEWS[tag] = vim.api.nvim_create_buf(false, true)
        
        vim.cmd('vsplit')
        local win_id = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win_id, VIEWS[tag])

        vim.api.nvim_create_autocmd("WinClosed", {
            pattern = tostring(win_id),
            callback = function()
                VIEWS[tag] = nil
                return true
            end
        })
    end

    -- Modernized Option Setting (No more Neovim 0.9 checks)
    vim.api.nvim_set_option_value("filetype", filetype or "rust", { buf = VIEWS[tag] })

    if type(view) == "string" then
        local view_lines = util.string_to_line_array(view)
        vim.api.nvim_buf_set_lines(VIEWS[tag], 0, -1, false, add_header(view_lines, header))
    else
        vim.api.nvim_buf_set_lines(VIEWS[tag], 0, -1, false, add_header(view, header))
    end
end

return M
