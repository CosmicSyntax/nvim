local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable TailwindCSS-LSP
vim.lsp.config["tw"] = {
	capabilities = capabilities,
	cmd = { 'tailwindcss-language-server', '--stdio' },
	-- filetypes copied and adjusted from tailwindcss-intellisense
	filetypes = {
		-- html
		'django-html',
		'htmldjango',
		'gohtml',
		'gohtmltmpl',
		'html',
		'htmlangular',
		'markdown',
		-- css
		'css',
		'less',
		'postcss',
		'sass',
		'scss',
		'stylus',
		'sugarss',
		-- js
		'javascript',
		'javascriptreact',
		'typescript',
		'typescriptreact',
		-- mixed
		'vue',
		'svelte',
		'templ',
	},
	settings = {
		tailwindCSS = {
			validate = true,
			lint = {
				cssConflict = 'warning',
				invalidApply = 'error',
				invalidScreen = 'error',
				invalidVariant = 'error',
				invalidConfigPath = 'error',
				invalidTailwindDirective = 'error',
				recommendedVariantOrder = 'warning',
			},
			classAttributes = {
				'class',
				'className',
				'class:list',
				'classList',
				'ngClass',
			},
		},
	},
	root_markers = {
		'package.json',
		'tailwind.config.js',
		'tailwind.config.ts',
	},
}
vim.lsp.enable('tw')
