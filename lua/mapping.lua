local cmd = vim.cmd

cmd([[autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>]])
cmd([[set wildignore+=target/**]])

local map = vim.api.nvim_set_keymap
local defo = { noremap = true, silent = true }

-- Show dianostic popup on cursor hold
map("n", "<space>d", ':lua vim.diagnostic.open_float()<CR>', defo)

-- Mapping for Telescope
map("n", "<F9>", ':Telescope find_files<CR>', defo)
map("n", "<F8>", ':Telescope live_grep<CR>', defo)
map("n", "<F10>", ':Telescope quickfix<CR>', defo)
map("n", "<F11>", ':Telescope buffers<CR>', defo)

-- Mapping for Packer
map("n", "<leader>pp", ':lua require("plugins")<CR>', defo)

-- Mapping for copy into clipboard
map("v", "<C-c>", '"+y', defo)

-- Mapping for Nvim Tree Explorer
map("n", "<F7>", ':NvimTreeToggle<CR>', defo)
map("n", "<leader>r", ':NvimTreeRefresh<CR>', defo)
map("n", "<leader>n", ':NvimTreeFindFile<CR>', defo)

-- Mapping for maximizing buffer
map("n", "<leader>mm", ':WindowsMaximize<CR>', defo)

-- Mapping Trouble diagnostics
map("n", "<space>a", ':TroubleToggle<CR>', defo)
map("n", "<space>q", ':TroubleToggle quickfix<CR>', defo)

-- Mapping for Gitsigns
map("n", "]c", ':Gitsigns next_hunk<CR>', defo)
map("n", "[c", ':Gitsigns prev_hunk<CR>', defo)
map("n", "<leader>gs", ':Gitsigns stage_hunk<CR>', defo)
map("n", "<leader>gr", ':Gitsigns reset_hunk<CR>', defo)
map("n", "<leader>gp", ':Gitsigns preview_hunk<CR>', defo)
map("n", "<leader>gb", ':Git blame_line<CR>', defo)

-- Mapping for LSP configuration
map("n", "K", '<cmd>lua vim.lsp.buf.hover()<CR>', defo)
map("n", "<c-k>", '<cmd>lua vim.lsp.buf.signature_help()<CR>', defo)
map("n", "gi", '<cmd>lua vim.lsp.buf.implementation()<CR>', defo)
map("n", "gr", '<cmd>lua vim.lsp.buf.references()<CR>', defo)
map("n", "gd", '<cmd>lua vim.lsp.buf.definition()<CR>', defo)
map("n", "gD", '<cmd>lua vim.lsp.buf.declaration()<CR>', defo)
map("n", "g0", '<cmd>lua vim.lsp.buf.document_symbol()<CR>', defo)
map("n", "gw", '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', defo)
map("n", "ga", '<cmd>lua vim.lsp.buf.code_action()<CR>', defo)
map("n", "gt", '<cmd>lua vim.lsp.buf.type_definition()<CR>', defo)

-- Mapping for moving around tabs
map("n", "<C-l>", ':BufferLineCycleNext<CR>', defo)
map("n", "<C-h>", ':BufferLineCyclePrev<CR>', defo)
map("n", "<C-j>", ':BufferLineMoveNext<CR>', defo)
map("n", "<C-k>", ':BufferLineMovePrev<CR>', defo)

-- Mapping for Lazygit
map("n", "<leader>gg", ':LazyGit<CR>', defo)

-- Mapping for vimspector debugging
map("n", "<leader>vl", ':call vimspector#Launch()<CR>', defo)
map("n", "<leader>vr", ':VimspectorReset<CR>', defo)
map("n", "<leader>vb", ':call vimspector#ToggleBreakpoint()<CR>', defo)
map("n", "<leader>vn", ':call vimspector#StepOver()<CR>', defo)
map("n", "<leader>vs", ':call vimspector#StepInto()<CR>', defo)
map("n", "<leader>vo", ':call vimspector#StepOut()<CR>', defo)
map("n", "<leader>vh", ':call vimspector#RunToCursor()<CR>', defo)
map("n", "<leader>vc", ':call vimspector#Continue()<CR>', defo)
local g = vim.g
g.vimspector_install_gadgets = [['CodeLLDB']]
g.vimspector_variables_display_mode = 'full'

-- Mapping for TS spacing
map("n", "<leader>ts", ':set shiftwidth=2 | set tabstop=2 | set expandtab<CR>', defo)

-- Mapping for Neoformat
map("n", "<leader>f", ':lua vim.lsp.buf.format()<CR>', defo)
