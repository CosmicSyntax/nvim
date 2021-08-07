set number
set tabstop=4
set shiftwidth=4
set noexpandtab
set mouse=a
set signcolumn=yes

set completeopt=menuone,noinsert,noselect
set shortmess+=c

set guicursor=n:block-blinkon250,v:block-blinkon250,i:ver100-blinkon250

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=1000

set foldmethod=indent
"set foldlevel=1
set nofoldenable

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'terryma/vim-multiple-cursors'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-rhubarb'
Plug 'voldikss/vim-floaterm'
Plug 'sebdah/vim-delve'
Plug 'jiangmiao/auto-pairs'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'wellle/context.vim'
Plug 'gruvbox-community/gruvbox'
"Plug 'mattn/emmet-vim'
"Plug 'preservim/nerdtree'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'matze/vim-move'
"Plug 'easymotion/vim-easymotion'
"Plug 'tpope/vim-sleuth'
"Plug 'dense-analysis/ale'
"Plug 'puremourning/vimspector'
"Plug 'mfussenegger/nvim-dap'
"Plug 'tomasr/molokai', {'as': 'molokai'}
"Plug 'itchyny/lightline.vim'
call plug#end()

"NVIM CONFIG
lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
}

-- nvim_lsp object
local nvim_lsp = require'lspconfig'
require("trouble").setup{}

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
	on_attach=on_attach,
	settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        },
    },
})

-- Enable Gopls
nvim_lsp.gopls.setup({
	on_attach=on_attach,
	settings = {
		analyses = {
			unusedparams = true,
		},
		staticcheck = true,
	}
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = true,
		signs = true,
		update_in_insert = true,
	}
)

--[[
do
	local method = "textDocument/publishDiagnostics"
	local default_handler = vim.lsp.handlers[method]
	vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
		default_handler(err, method, result, client_id, bufnr, config)
		local diagnostics = vim.lsp.diagnostic.get_all()
		print(vim.inspect(diagnostics))
		local qflist = {}
		for bufnr, diagnostic in pairs(diagnostics) do
			for _, d in ipairs(diagnostic) do
				d.bufnr = bufnr
				d.lnum = d.range.start.line + 1
				d.col = d.range.start.character + 1
				d.text = d.message
				table.insert(qflist, d)
			end
		end
	vim.lsp.util.set_qflist(qflist)
	end
end
--]]

EOF

" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint"} }

" Ignore vimgrep
set wildignore+=target/**

" Enable 24-bit colors if supported
set termguicolors

" Indent config
let g:indent_guides_color_change_percent=5
let g:indent_guides_start_level=2

" Map fzf
nnoremap <F8> :GFiles<CR>
nnoremap <F9> :Files<CR>

" Copy remap
vnoremap <C-c> "+y

" Get link to github
nnoremap <space>g :.GBrowse!<CR>

" Theme Customization
let g:gruvbox_contrast_dark='soft'
"let g:gruvbox_material_palette='material'
set background=dark
colorscheme gruvbox

hi Comment gui=italic

" Tree Customization
nnoremap <F7> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" Trouble Customization
nnoremap <space>a :TroubleToggle<CR>

" Airline Customization
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:gitgutter_enabled=0 " Just toggle it
nmap <leader>dm :let g:gitgutter_diff_base = 'master'<CR>
nmap <leader>db :let g:gitgutter_diff_base = 'head'<CR>
nmap <leader>dt :GitGutterToggle<CR>
nmap <leader>dp <Plug>(GitGutterPreviewHunk)


" LSP configuration
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gt   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
