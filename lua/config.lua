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

-- One Nord... because there is nothing better
require('onenord').setup({
		theme = nil,
		borders = false,
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
	inverse = {
		match_paren = false,
	},
	custom_highlights = {},
	custom_colors = {},
})
vim.cmd("colorscheme onenord")
-- cmd([[highlight Comment cterm=italic gui=italic]])
-- cmd([[highlight Function cterm=bold gui=bold]])

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
