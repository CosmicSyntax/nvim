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

-- Setup lsp_status
local lsp_status = require('lsp-status')
lsp_status.register_progress()
local lspconfig = require('lspconfig')
lspconfig.rust_analyzer.setup({
	on_attach = lsp_status.on_attach,
	capabilities = lsp_status.capabilities
})
lspconfig.gopls.setup({
	on_attach = lsp_status.on_attach,
	capabilities = lsp_status.capabilities
})
lsp_status.config ({
	status_symbol = '⛩',
	indicator_errors = 'E',
	indicator_warnings = 'W',
	indicator_info = 'i',
	indicator_hint = '?',
	indicator_ok = 'Ok',
})

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
		lualine_c = {{lsp_status.status},
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
	extensions = {'fzf', 'nvim-tree', 'fugitive', 'quickfix'},
}

-- Trouble - dx
require("trouble").setup {
	icons = false,
}

-- Setup nvim-cmp.
local cmp = require'cmp'
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
    },
    mapping = {
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
})

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- stop nvim_lsp auto jump for GI
local log = require 'vim.lsp.log'
local util = require 'vim.lsp.util'
vim.lsp.handlers["textDocument/implementation"] = function(_, result, ctx, _)
	if result == nil or vim.tbl_isempty(result) then
		local _ = log.info() and log.info(ctx.method, 'No location found')
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
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
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
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	settings = {
		analyses = {
			unusedparams = true,
			},
		staticcheck = true,
	}
})


-- Enable Pyright
nvim_lsp.pyright.setup({
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
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
autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = " ➜ ",
	\ highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

" Ignore vimgrep
set wildignore+=target/**

" Map fzf
nnoremap <F8> :GFiles<CR>
nnoremap <F9> :Files<CR>

" Map Lua Packer
nnoremap <leader>pp :lua require('plugins')<CR>

" Copy remap
vnoremap <C-c> "+y

" Get link to github
nnoremap <space>g :.GBrowse!<CR>

" Theme Customization
set background=dark
colorscheme gruvbox8_hard
let g:gruvbox_filetype_hi_groups = 1
let g:gruvbox_italics = 0
let g:gruvbox_italicize_strings = 0

" Enable 24-bit colors if supported and italic comments
" This needs to be set after Theme, or the theme overrides it
set termguicolors
hi Comment gui=italic cterm=italic

" Tree Customization
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
