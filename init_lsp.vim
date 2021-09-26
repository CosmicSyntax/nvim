set relativenumber
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
Plug 'hoob3rt/lualine.nvim'
Plug 'romgrk/barbar.nvim'
Plug 'terryma/vim-multiple-cursors'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-rhubarb'
Plug 'numToStr/FTerm.nvim'
Plug 'sebdah/vim-delve'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'chrisbra/Colorizer'
Plug 'psliwka/vim-smoothie'
Plug 'ellisonleao/glow.nvim'
Plug 'kevinhwang91/nvim-bqf'
"Plug 'jiangmiao/auto-pairs'
"Plug 'vim-airline/vim-airline'
"Plug 'wellle/context.vim'
"Plug 'puremourning/vimspector'
"Plug 'preservim/nerdtree'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'matze/vim-move'
"Plug 'easymotion/vim-easymotion'
"Plug 'tpope/vim-sleuth'
"Plug 'dense-analysis/ale'
"Plug 'mfussenegger/nvim-dap'
"Plug 'tomasr/molokai', {'as': 'molokai'}
"Plug 'itchyny/lightline.vim'
call plug#end()

" NVIM CONFIG
lua <<EOF

-- Nvim native treesitter configuration
require'nvim-treesitter.configs'.setup {
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

-- Nvim tree navigator setup
require'nvim-tree'.setup {}

-- Better QF config
require'bqf'.setup {
	auto_enable = true,
    preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'}
    },
    func_map = {
        vsplit = '',
        ptogglemode = 'z,',
        stoggleup = ''
    },
    filter = {
        fzf = {
            action_for = {['ctrl-s'] = 'split'},
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
        }
    }
}

-- Line Setup
require'lualine'.setup {
	options = {
		icons_enabled = false,
		theme = 'gruvbox',
		component_separators = {'▚', '▞'},
		section_separators = {'', ''},
		disabled_filetypes = {}
		},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {
			'branch',
			{
				'filename',
				file_status = true,
				path = 1,
			},
		},
		lualine_c = {
			{
				'diagnostics',
				sources = {'nvim_lsp'},
				symbols = {error = 'E ', warn = 'W ', info = 'I '},
			},
		},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
		},
	tabline = {},
	extensions = {'fzf', 'nvim-tree', 'fugitive'}
}

-- Trouble - dx
require("trouble").setup {
	icons = false,
}

-- function to attach completion when setting up lsp
local on_attach = function(client)
require'completion'.on_attach(client)
end

-- nvim_lsp object
local nvim_lsp = require'lspconfig'


-- stop nvim_lsp auto jump for GI
local log = require 'vim.lsp.log'
local util = require 'vim.lsp.util'
vim.lsp.handlers["textDocument/implementation"] = function(_, method, result)
	if result == nil or vim.tbl_isempty(result) then
		local _ = log.info() and log.info(method, 'No location found')
		return nil
	end
	if vim.tbl_islist(result) then
		if #result > 1 then
			util.set_qflist(util.locations_to_items(result))
			vim.api.nvim_command("copen")
		end
	else
		util.jump_to_location(result)
	end
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


-- Enable Pyright
nvim_lsp.pyright.setup({
	on_attach=on_attach,
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = true,
		signs = true,
		update_in_insert = true,
	}
)

-- Tabline config
vim.g.bufferline = {
	icons = false,
	icon_close_tab = 'x',
}

EOF

" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Close copen upon selecting item
autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

" Enable type inlay hints
autocmd BufEnter,BufWinEnter,TabEnter *.rs
	\ lua require'lsp_extensions'.inlay_hints{ prefix = '', aligned = true,
	\ highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

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
let g:nvim_tree_lsp_diagnostics = 1
nnoremap <F7> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" Inline Terminal Customization
nnoremap <leader>to :lua require('FTerm').open()<CR>
nnoremap <leader>tt :lua require('FTerm').toggle()<CR>

" Trouble Customization
nnoremap <space>a :TroubleToggle<CR>

" Gitgutter config
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

" Tab navigation
nnoremap <C-h> :BufferPrevious<CR>
nnoremap <C-l> :BufferNext<CR>
