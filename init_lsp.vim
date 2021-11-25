set number relativenumber
set tabstop=4
set shiftwidth=4
set noexpandtab
set mouse=a
set signcolumn=yes
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set guicursor=n:block-blinkon250,v:block-blinkon250,i:ver100-blinkon250
" Set updatetime for CursorHold
set updatetime=1000
set foldmethod=indent
"set foldlevel=1
set nofoldenable
set winblend=20

" NVIM CONFIG
lua << END

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
		-- icons_enabled = false,
		theme = 'nightfox',
		component_separators = {'|', '|'},
		section_separators = {'', ''},
		disabled_filetypes = {'minimap'}
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
		lualine_c = {'lsp_progress'},
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
	extensions = {'fzf', 'nvim-tree', 'fugitive', 'quickfix', 'toggleterm'},
}

-- Trouble - dx
require("trouble").setup {
	icons = true,
}

-- Setup nvim-cmp.
local cmp = require'cmp'
local lspkind = require('lspkind')
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
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
	formatting = {
		format = lspkind.cmp_format({with_text = true, maxwidth = 50}),
	},
})

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
		else
			util.jump_to_location(result[1])
		end
	else
		util.jump_to_location(result)
	end
end

-- nvim_lsp object
local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
	-- capabilities = cmp.update_capabilities(lsp_status.capabilities);

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
	capabilities = capabilities,
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
	capabilities = capabilities,
	settings = {
		analyses = {
			unusedparams = true,
			},
		staticcheck = true,
	},
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
require('bufferline').setup {
	highlights = {
		buffer_selected = {
			gui = "bold",
		},
		error_selected = {
			gui = "bold",
		},
		error_diagnostic_selected = {
			gui = "bold",
		},
		info_selected = {
			gui = "bold",
		},
		info_diagnostic_selected = {
			gui = "bold",
		},
		warning_selected = {
			gui = "bold",
		},
		warning_diagnostic_selected = {
			gui = "bold",
		},
		duplicate_selected = {
			gui = "",
		},
		duplicate_visible = {
			gui = "",
		},
		duplicate = {
			gui = "",
		},

	},
	options = {
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			return "("..count..")"
		end,
		offsets = {{filetype = "NvimTree", text = "Navigation", text_align = "left"}},
		buffer_close_icon = 'x',
		show_buffer_icons = true,
		show_buffer_close_icons = false,
		show_close_icon = false,
		show_tab_indicators = true,
		persist_buffer_sort = true,
		separator_style = "thin",
		custom_areas = {
			right = function()
				local result = {}
				local error = vim.lsp.diagnostic.get_count(0, [[Error]])
				local warning = vim.lsp.diagnostic.get_count(0, [[Warning]])
				local info = vim.lsp.diagnostic.get_count(0, [[Information]])
				local hint = vim.lsp.diagnostic.get_count(0, [[Hint]])

				if error ~= 0 then
					table.insert(result, {text = " E " .. error, guifg = "#EC5241"})
				end

				if warning ~= 0 then
					table.insert(result, {text = " W " .. warning, guifg = "#EFB839"})
				end

				if hint ~= 0 then
					table.insert(result, {text = " H " .. hint, guifg = "#A3BA5E"})
				end

				if info ~= 0 then
					table.insert(result, {text = " I " .. info, guifg = "#7EA9A7"})
				end
				return result
			end,
		}
	},
}

-- NightFox
local nightfox = require('nightfox')
nightfox.setup({
	fox = "nordfox",
	styles = {
		comments = "italic",
		functions = "bold"
	},
	colors = {
		red = "#FF000",
		bg_alt = "#000000",
	},
	hlgroups = {
		TSPunctDelimiter = { fg = "${red}" },
		LspCodeLens = { bg = "#000000", style = "italic" },
	}
})
nightfox.load()

-- Diffview Config
require'diffview'.setup {
	diff_binaries = false,
	enhanced_diff_hl = false,
	use_icons = true,
	file_panel = {
		position = "left",
		width = 35,
		height = 10,
		listing_style = "tree",
		tree_options = {
			flatten_dirs = true,
			folder_statuses = "always"
		}
	},
	file_history_panel = {
		position = "bottom",
		width = 35,
		height = 16,
		log_options = {
			max_count = 256,
			follow = false,
			all = false,
			merges = false,
			no_merges = false,
			reverse = false,
		},
	},
}

-- Terminal Config
require("toggleterm").setup {
	direction = "horizontal",
}
function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Smooth scrolling
require('neoscroll').setup {
	easing_function = "quadratic",
}

END

" Show diagnostic popup on cursor hold
" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

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

" Enable 24-bit colors if supported and italic comments
" This needs to be set after Theme, or the theme overrides it
set termguicolors
hi Comment gui=italic cterm=italic

" Tree Customization
nnoremap <F7> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" Inline Terminal Customization
nnoremap <leader>tt :ToggleTerm<CR>

" Vim Maximizer Toggle Keybind
nnoremap <leader>mm :MaximizerToggle<CR>

" Trouble Customization
nnoremap <space>a :TroubleToggle<CR>

" Gitgutter config
let g:gitgutter_enabled=0 " Just toggle it
nmap <leader>dm :let g:gitgutter_diff_base = 'master'<CR>
nmap <leader>db :let g:gitgutter_diff_base = 'head'<CR>
nmap <leader>dt :GitGutterToggle<CR>
nmap <leader>dp <Plug>(GitGutterPreviewHunk)

" Fugitive Config
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>

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
nnoremap <C-l> :BufferLineCycleNext<CR>
nnoremap <C-h> :BufferLineCyclePrev<CR>
