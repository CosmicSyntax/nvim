set cmdheight=0
set number relativenumber
set tabstop=4
set shiftwidth=4
set noexpandtab
set mouse=a
set signcolumn=yes
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set guicursor=n:block-blinkon250,v:hor100-blinkon250,i:ver100-blinkon250
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

-- Nvim tree lua
require'nvim-tree'.setup {
	view = {
		width = 40,
	},
}

-- Nvim autopair
require'nvim-autopairs'.setup {}

-- Nvim Comment
require('Comment').setup()

-- Nvim Git linker
require("gitlinker").setup()

-- Nvim Telescope
require("telescope").setup {
	defaults = {
		vimgrep_arguments = {
			'rg',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case',
			'-.'
		},
	},
	pickers = {
		find_files = {
			-- theme = "dropdown",
		},
		live_grep = {
			-- theme = "dropdown",
		}
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown {}
		}
	}
}
require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")

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
}

-- OneNord
local colortheme = require('onenord')
colortheme.setup({
	theme = nil,
	borders = true,
	fade_nc = false,
	styles = {
		comments = "italic",
		strings = "NONE",
		keywords = "NONE",
		functions = "bold",
		variables = "NONE",
		diagnostics = "underline",
		},
	disable = {
		background = false,
		cursorline = false,
		eob_lines = true,
	},
	custom_highlights = {},
	custom_colors = {},
})
colortheme.load()

-- Line Setup
require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'onenord',
		section_separators = { left = '', right = '' },
		component_separators = { left = '', right = '' },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = true,
	};
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
	};
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	};
	tabline = {},
	extensions = {'fzf', 'nvim-tree', 'quickfix'},
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
		{ name = 'path' },
	},
	formatting = {
		format = lspkind.cmp_format({with_text = true, maxwidth = 50}),
	},
})

-- stop nvim_lsp auto jump for GI
local log = require 'vim.lsp.log'
local util = require 'vim.lsp.util'
local jump_handle = function(_, result, ctx, _)
	if result == nil or vim.tbl_isempty(result) then
		local _ = log.info() and log.info(ctx.method, 'No location found')
		return nil
	end
	local client = vim.lsp.get_client_by_id(ctx.client_id)

	if vim.tbl_islist(result) then
		if #result > 1 then
			vim.fn.setqflist({}, ' ', {
				title = 'LSP locations',
				items = util.locations_to_items(result, client.offset_encoding)
				})
			vim.api.nvim_command("botright copen")
		else 
			util.jump_to_location(result[1], client.offset_encoding)
		end
	else
		util.jump_to_location(result, client.offset_encoding)
	end
end
vim.lsp.handlers["textDocument/implementation"] = jump_handle
vim.lsp.handlers["textDocument/definition"] = jump_handle
vim.lsp.handlers["textDocument/typeDefinition"] = jump_handle

-- nvim_lsp object
local nvim_lsp = require'lspconfig'
local cmp = require('cmp_nvim_lsp')
local capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
	-- capabilities = cmp.update_capabilities(lsp_status.capabilities);

-- Enable rust_analyzer
local opts = {
	tools = {
		autoSetHints = true,
		hover_with_actions = true,
		inlay_hints = {
			parameter_hints_prefix = "",
			other_hints_prefix = "",
			highlight = "BufferLineDiagnosticVisible",
		},
		hover_actions = {
			border = {
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{"▕", "FloatBorder"},
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{"▏", "FloatBorder"},
			},
			auto_focus = false,
		},
	},
	server = {
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				assist = {
					importGranularity = "module",
					importPrefix = "by_self",
				},
				cargo = {
					loadOutDirsFromCheck = true,
				},
				procMacro = {
					enable = true,
				},
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}
require('rust-tools').setup(opts)

-- Enable ClangD
nvim_lsp.clangd.setup({
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--background-index",
		"--suggest-missing-includes",
		'--query-driver="/usr/local/opt/gcc-arm-none-eabi-8-2019-q3-update/bin/arm-none-eabi-gcc"'
		},
	filetypes = {"c", "cpp", "objc", "objcpp"},
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

-- Enable Solargraph
nvim_lsp.solargraph.setup({
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	},
})

-- Enable Typescript
nvim_lsp.tsserver.setup({
	capabilities = capabilities,
    init_options = require("nvim-lsp-ts-utils").init_options,

    on_attach = function(client, bufnr)
        local ts_utils = require("nvim-lsp-ts-utils")

        -- defaults
        ts_utils.setup({
            debug = false,
            disable_commands = false,
            enable_import_on_completion = false,

            -- import all
            import_all_timeout = 5000, -- ms
            -- lower numbers = higher priority
            import_all_priorities = {
                same_file = 1, -- add to existing import statement
                local_files = 2, -- git files or files with relative path markers
                buffer_content = 3, -- loaded buffer content
                buffers = 4, -- loaded buffer names
            },
            import_all_scan_buffers = 100,
            import_all_select_source = false,
            -- if false will avoid organizing imports
            always_organize_imports = true,

            -- filter diagnostics
            filter_out_diagnostics_by_severity = {},
            filter_out_diagnostics_by_code = {},

            -- inlay hints
            auto_inlay_hints = true,
            inlay_hints_highlight = "BufferLineDiagnosticVisible",
            inlay_hints_priority = 200, -- priority of the hint extmarks
            inlay_hints_throttle = 150, -- throttle the inlay hint request
            inlay_hints_format = { -- format options for individual hint kind
                Parameter = {},
                Enum = {},
				Type = {
					highlight = "BufferLineDiagnosticVisible",
					text = function(text)
					return text:sub(3)
					end,
				},
            },

            -- update imports on file move
            update_imports_on_move = false,
            require_confirmation_on_move = false,
            watch_dir = nil,
        })

        -- required to fix code action ranges and filter diagnostics
        ts_utils.setup_client(client)

        -- no default maps, so you may want to define some here
        local opts = { silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
    end,
})

-- Enable PyLsp
nvim_lsp.pylsp.setup{}

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
			gui = None,
		},
		duplicate_visible = {
			gui = None,
		},
		duplicate = {
			gui = None,
		},

	},
	options = {
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			return "("..count..")"
		end,
		offsets = {
			{
				filetype = "NvimTree",
				text = "Navigation", 
				text_align = "center",
				padding = 1,
			}
		},
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

				local error = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})
				local warning = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})
				local info = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO})
				local hint = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT})

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

-- Gitsigns
require('gitsigns').setup({
	current_line_blame = false,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'eol',
		delay = 1000,
		ignore_whitespace = false,
	},
})

-- Diffview Config
require'diffview'.setup {
	diff_binaries = false,
	enhanced_diff_hl = false,
	use_icons = true,
	file_panel = {
		win_config = {
			position = "left",
			width = 35,
			height = 10,
		},
		listing_style = "tree",
		tree_options = {
			flatten_dirs = true,
			folder_statuses = "always"
		}
	},
	file_history_panel = {
		win_config = {
			position = "bottom",
			width = 35,
			height = 16,
		},
		log_options = {
			single_file = {

				max_count = 256,
				follow = false,
				all = false,
				merges = false,
				no_merges = false,
				reverse = false,
			},
			multi_file = {
				max_count = 256,
				follow = false,
				all = false,
				merges = false,
				no_merges = false,
				reverse = false,
			},
		},
	},
}

-- Smooth scrolling
require('neoscroll').setup {
	easing_function = "quadratic",
}

END

" Show diagnostic popup on cursor hold
" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
nnoremap <space>d :lua vim.diagnostic.open_float()<CR>

" Close copen upon selecting item
autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

" Ignore vimgrep
set wildignore+=target/**

" Map Telescope
nnoremap <F9> :Telescope find_files<CR>
nnoremap <F8> :Telescope live_grep<CR>
nnoremap <F10> :Telescope quickfix<CR>
nnoremap <F11> :Telescope buffers<CR>

" Map Lua Packer
nnoremap <leader>pp :lua require('plugins')<CR>

" Copy remap
vnoremap <C-c> "+y

" Enable 24-bit colors if supported
" This needs to be set after Theme, or the theme overrides it
set termguicolors

" Tree Customization
nnoremap <F7> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" Vim Maximizer Toggle Keybind
nnoremap <leader>mm :MaximizerToggle<CR>

" Trouble Customization
nnoremap <space>a :TroubleToggle<CR>
nnoremap <space>q :TroubleToggle quickfix<CR>

" Gitsigns Config
nnoremap ]c :Gitsigns next_hunk<CR>
nnoremap [c :Gitsigns prev_hunk<CR>
nnoremap <leader>gs :Gitsigns stage_hunk<CR>
nnoremap <leader>gr :Gitsigns reset_hunk<CR>
nnoremap <leader>gp :Gitsigns preview_hunk<CR>
nnoremap <leader>gb :Git blame_line<CR>

" LSP configuration
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" setup mapping to call :LazyGit
nnoremap <silent> <leader>gg :LazyGit<CR>

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
nnoremap <silent><C-l> :BufferLineCycleNext<CR>
nnoremap <silent><C-h> :BufferLineCyclePrev<CR>
nnoremap <silent><C-j> :BufferLineMoveNext<CR>
nnoremap <silent><C-k> :BufferLineMovePrev<CR>

" vimspector mapping and setup
nmap <leader>vl :call vimspector#Launch()<CR>
nmap <leader>vr :VimspectorReset<CR>
nmap <leader>ve :VimspectorEval
nmap <leader>vw :VimspectorWatch
nmap <leader>vo :VimspectorShowOutput
nmap <leader>vi <Plug>VimspectorBalloonEval
xmap <leader>vi <Plug>VimspectorBalloonEval
nnoremap <leader>vb :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>vn :call vimspector#StepOver()<CR>
nnoremap <leader>vs :call vimspector#StepInto()<CR>
nnoremap <leader>vo :call vimspector#StepOut()<CR>
nnoremap <leader>vh :call vimspector#GoToCurrentLine()<CR>
nnoremap <leader>vc :call vimspector#Continue()<CR>
let g:vimspector_install_gadgets = [ 'CodeLLDB' ]

 " typescript spacing
nnoremap <leader>ts :set shiftwidth=2 \| set tabstop=2 \| set expandtab<CR>

" Formatting files
nnoremap <leader>f :Neoformat<CR>
