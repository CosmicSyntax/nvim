-- Treesitter
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
-- require('lualine').setup {
-- 	options = {
-- 		icons_enabled = true,
-- 		theme = 'onenord',
-- 		section_separators = { left = '', right = '' },
-- 		component_separators = { left = '', right = '' },
-- 		disabled_filetypes = {},
-- 		always_divide_middle = true,
-- 		globalstatus = true,
-- 	};
-- 	sections = {
-- 		lualine_a = {'mode'},
-- 		lualine_b = {
-- 			'branch',
-- 			{
-- 				'filename',
-- 				file_status = true,
-- 				path = 1,
-- 			},
-- 			'diff',
-- 		},
-- 		lualine_c = {'diagnostics', 'lsp_progress'},
-- 		lualine_x = {'encoding', 'fileformat', 'filetype'},
-- 		lualine_y = {'progress'},
-- 		lualine_z = {'location'},
-- 	};
-- 	inactive_sections = {
-- 		lualine_a = {},
-- 		lualine_b = {},
-- 		lualine_c = {'filename'},
-- 		lualine_x = {'location'},
-- 		lualine_y = {},
-- 		lualine_z = {}
-- 	};
-- 	tabline = {},
-- 	extensions = {'nvim-tree', 'quickfix'},
-- }
-- vim.o.laststatus = 3

-- Trouble - dx
require("trouble").setup {
	icons = true,
	action_keys = {
        close_folds = "tc",
        open_folds = "to",
    },
}

-- Setup nvim-cmp.
local cmp = require'cmp'
local lspkind = require('lspkind')
require("luasnip.loaders.from_vscode").lazy_load()
local snip = require('luasnip')
cmp.setup({
	snippet = {
		expand = function(args)
			snip.lsp_expand(args.body)
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
		{ name = 'crates' },
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
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- capabilities = cmp.update_capabilities(lsp_status.capabilities)

-- Enable rust_analyzer
local rt = require('rust-tools')
local opts = {
	tools = {
		auto = false,
		on_initialized = nil,

		-- These apply to the default RustSetInlayHints command
		inlay_hints = {
			auto = true,
			only_current_line = false,
			show_parameter_hints = true,
			parameter_hints_prefix = "",
			other_hints_prefix = "-> ",
			max_len_align = false,
			max_len_align_padding = 1,
			right_align = false,
			right_align_padding = 7,
			highlight = "BufferLineDiagnosticVisible",
		},
		hover_actions = {
			border = {
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{" ", "FloatBorder"},
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{"", "FloatBorder"},
				{" ", "FloatBorder"},
			},
			auto_focus = false,
		},
	},
	server = {
		capabilities = capabilities,
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
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
					attributes = {
						enabled = true,
					}
				},
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}
rt.setup(opts)

-- Enable LSP Signature
require "lsp_signature".setup({
	floating_window = false
})

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
	filetypes = { "go", "gomod" },
	cmd = {'gopls', '--remote=auto'},
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


-- Enable R LSP
nvim_lsp.r_language_server.setup{
	capabilities = capabilities,
}

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
			bold = true,
		},
		error_selected = {
			bold = true,
		},
		error_diagnostic_selected = {
			bold = true,
		},
		info_selected = {
			bold = true,
		},
		info_diagnostic_selected = {
			bold = true,
		},
		warning_selected = {
			bold = true,
		},
		warning_diagnostic_selected = {
			bold = true,
		},
		-- duplicate_selected = {
		-- 	gui = None,
		-- },
		-- duplicate_visible = {
		-- 	gui = None,
		-- },
		-- duplicate = {
		-- 	gui = None,
		-- },
	},
	options = {
		-- diagnostics = "nvim_lsp",
		-- diagnostics_update_in_insert = false,
		-- diagnostics_indicator = function(count, level, diagnostics_dict, context)
		-- 	return "("..count..")"
		-- end,
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
		-- custom_areas = {
		-- 	right = function()
		-- 		local result = {}
  --
		-- 		local error = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})
		-- 		local warning = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})
		-- 		local info = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO})
		-- 		local hint = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT})
  --
		-- 		if error ~= 0 then
		-- 			table.insert(result, {text = " E " .. error, guifg = "#EC5241"})
		-- 		end
  --
		-- 		if warning ~= 0 then
		-- 			table.insert(result, {text = " W " .. warning, guifg = "#EFB839"})
		-- 		end
  --
		-- 		if hint ~= 0 then
		-- 			table.insert(result, {text = " H " .. hint, guifg = "#A3BA5E"})
		-- 		end
  --
		-- 		if info ~= 0 then
		-- 			table.insert(result, {text = " I " .. info, guifg = "#7EA9A7"})
		-- 		end
		-- 		return result
		-- 	end,
		-- }
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

-- Window management
require('windows').setup({
	autowidth = {
		winwidth = 15,
	}
})
