-- ==========================================
-- 1. General Settings & Autocommands
-- ==========================================
vim.opt.wildignore:append("target/**")

-- Modern autocommand to close quickfix list on Enter
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "<CR>", "<CR><cmd>cclose<CR>",
			{ buffer = true, silent = true, desc = "Jump to error and close Quickfix" })
	end,
})

-- ==========================================
-- 2. Keymaps Setup
-- ==========================================
local map = vim.keymap.set
-- We no longer need `noremap = true` because it is the default for vim.keymap.set
local opts = { silent = true }

-- Copilot
map("i", "<C-a>", function() require("copilot.suggestion").accept() end, { desc = "Copilot Accept" })
map("i", "<C-s>", function() require("copilot.suggestion").next() end, { desc = "Copilot Next" })

-- Buffer Management (Leaving command line open for input)
map("n", "<leader>l", ":ls<CR>:b ", { silent = false, desc = "List and switch buffers" })
map("n", "<leader>d", ":ls<CR>:bd ", { silent = false, desc = "List and delete buffers" })

-- Horizontal scrolling
map("n", "<C-h>", "20zh", { silent = true, desc = "Scroll Left" })
map("n", "<C-l>", "20zl", { silent = true, desc = "Scroll Right" })

-- Terminal launch
map("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { silent = true, desc = "Terminal (Vertical)" })
map("n", "<leader>ts", "<cmd>split | terminal<CR>", { silent = true, desc = "Terminal (Horizontal)" })
map("t", "<C-space>", "<C-\\><C-n>", { silent = true, desc = "Exit Terminal Mode" })

-- Copy to system clipboard
map("v", "<C-c>", '"+y', { silent = true, desc = "Yank to System Clipboard" })

-- Formatting & Spacing tweaks
map("n", "<leader>st", "<cmd>set shiftwidth=2 | set tabstop=2 | set expandtab<CR>",
	{ silent = true, desc = "Set 2-space tabs" })
map("n", "<leader>f", vim.lsp.buf.format, { silent = true, desc = "Format Buffer" })

-- Plugin Manager
map("n", "<leader>pp", function() vim.pack.update() end, { silent = true, desc = "Update Plugins" })

-- ==========================================
-- 3. UI & Navigation Plugins
-- ==========================================
-- Nvim Tree
map("n", "<F7>", "<cmd>NvimTreeToggle<CR>", opts)
map("n", "<leader>r", "<cmd>NvimTreeRefresh<CR>", opts)
map("n", "<leader>n", "<cmd>NvimTreeFindFile<CR>", opts)

-- Windows Maximize
map("n", "<leader>mm", "<cmd>WindowsMaximize<CR>", opts)

-- Telescope
map("n", "<F8>", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<F9>", "<cmd>Telescope find_files<CR>", opts)
map("n", "<F10>", "<cmd>Telescope quickfix<CR>", opts)
map("n", "<F11>", "<cmd>Telescope buffers<CR>", opts)
map("n", "<F12>", "<cmd>Telescope treesitter<CR>", opts)

-- ==========================================
-- 4. LSP & Diagnostics
-- ==========================================
-- Native Diagnostics
map("n", "<space>d", vim.diagnostic.open_float, { silent = true, desc = "Line Diagnostics" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
	{ silent = true, desc = "Next Diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
	{ silent = true, desc = "Prev Diagnostic" })

-- Trouble
map("n", "<space>a", "<cmd>Trouble diagnostics toggle<CR>", opts)
map("n", "<space>z", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", opts)
map("n", "<space>q", "<cmd>Trouble quickfix toggle<CR>", opts)

-- LSP Actions (Pure Lua)
map("n", "K", vim.lsp.buf.hover, { silent = true, desc = "LSP Hover" })
map("n", "<c-k>", vim.lsp.buf.signature_help, { silent = true, desc = "LSP Signature Help" })
map("n", "g0", vim.lsp.buf.document_symbol, { silent = true, desc = "LSP Document Symbols" })
map("n", "gw", vim.lsp.buf.workspace_symbol, { silent = true, desc = "LSP Workspace Symbols" })
map("n", "ga", vim.lsp.buf.code_action, { silent = true, desc = "LSP Code Action" })

-- LSP Jumping (via Trouble)
map("n", "gi", "<cmd>Trouble lsp_implementations toggle focus=true auto_jump=true auto_close=true<cr>", opts)
map("n", "gr", "<cmd>Trouble lsp_references toggle focus=true auto_jump=true auto_close=true<cr>", opts)
map("n", "gd", "<cmd>Trouble lsp_definitions toggle focus=true auto_jump=true auto_close=true<cr>", opts)
map("n", "gD", "<cmd>Trouble lsp_declarations toggle focus=true auto_jump=true auto_close=true<cr>", opts)
map("n", "gt", "<cmd>Trouble lsp_type_definitions toggle focus=true auto_jump=true auto_close=true<cr>", opts)

-- ==========================================
-- 5. Git & Debugging Tools
-- ==========================================
-- Gitsigns & Neogit
map("n", "]c", "<cmd>Gitsigns next_hunk<CR>", opts)
map("n", "[c", "<cmd>Gitsigns prev_hunk<CR>", opts)
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", opts)
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", opts)
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", opts)
map("n", "<leader>gb", "<cmd>Git blame_line<CR>", opts)
map("n", "<leader>gg", "<cmd>Neogit<CR>", opts)

-- Kulala (API testing)
map("n", "<leader>kr", function() require("kulala").run() end, { silent = true, desc = "Kulala Run" })
map("n", "<leader>ka", function() require("kulala").run_all() end, { silent = true, desc = "Kulala Run All" })

-- Vimspector
-- Note: Vimspector uses Vimscript functions extensively, so `<cmd>call...` is still the best approach here.
map("n", "<leader>vl", "<cmd>call vimspector#Launch()<CR>", opts)
map("n", "<leader>vr", "<cmd>VimspectorReset<CR>", opts)
map("n", "<leader>vb", "<cmd>call vimspector#ToggleBreakpoint()<CR>", opts)
map("n", "<leader>vn", "<cmd>call vimspector#StepOver()<CR>", opts)
map("n", "<leader>vs", "<cmd>call vimspector#StepInto()<CR>", opts)
map("n", "<leader>vo", "<cmd>call vimspector#StepOut()<CR>", opts)
map("n", "<leader>vh", "<cmd>call vimspector#RunToCursor()<CR>", opts)
map("n", "<leader>vc", "<cmd>call vimspector#Continue()<CR>", opts)

vim.g.vimspector_install_gadgets = { 'CodeLLDB' }
vim.g.vimspector_variables_display_mode = 'full'
