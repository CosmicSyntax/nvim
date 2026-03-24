local capabilities = require('lazyConfigs.shared')

-- Enable Gopls
vim.lsp.config['copilot'] = {
	capabilities = capabilities,
	cmd = {'copilot-language-server', '--stdio'},
	settings = {
		telemetry = {
			telemetryLevel = 'off',
		},
	},
}
vim.lsp.enable('copilot')
