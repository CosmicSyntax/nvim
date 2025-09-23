
local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

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
